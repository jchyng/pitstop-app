import '../../core/db/database.dart';
import '../../core/theme/tokens.dart';

enum ItemStatus { ok, warn, overdue, unknown }

class RemainingLifeResult {
  final ItemStatus status;
  final double? ratio;      // null → unknown; 0..1 (clamped) otherwise
  final int? remainingKm;   // distance axis; negative when overdue
  final int? remainingDays; // time axis; negative when overdue
  final bool isTimeDriven;  // true = time axis was more urgent

  const RemainingLifeResult({
    required this.status,
    this.ratio,
    this.remainingKm,
    this.remainingDays,
    this.isTimeDriven = false,
  });
}

/// 핸드오프 문서 §3.1–3.2 계산.
/// [today] 를 주입받아 테스트 가능하게 함.
RemainingLifeResult calculateRemainingLife(
  ItemSpec spec,
  int currentOdometer,
  DateTime today,
) {
  if (spec.lastReplacedOdometer == null && spec.lastReplacedDate == null) {
    return const RemainingLifeResult(status: ItemStatus.unknown);
  }

  double? ratioKm;
  int? remKm;

  if (spec.lastReplacedOdometer != null && spec.intervalKm != null) {
    remKm = spec.lastReplacedOdometer! + spec.intervalKm! - currentOdometer;
    ratioKm = remKm / spec.intervalKm!;
  }

  double? ratioTime;
  int? remDays;

  if (spec.lastReplacedDate != null && spec.intervalMonths != null) {
    final dueDate = _addMonths(spec.lastReplacedDate!, spec.intervalMonths!);
    remDays = dueDate.difference(today).inDays;
    ratioTime = remDays / (spec.intervalMonths! * 30.4);
  }

  // 이력은 있으나 계산 가능한 축이 없는 엣지 케이스 (interval 모두 null)
  if (ratioKm == null && ratioTime == null) {
    return const RemainingLifeResult(status: ItemStatus.unknown);
  }

  // 더 임박한 축(낮은 ratio) 채택
  final bool isTimeDriven;
  final double ratio;

  if (ratioKm != null && ratioTime != null) {
    isTimeDriven = ratioTime < ratioKm;
    ratio = isTimeDriven ? ratioTime : ratioKm;
  } else if (ratioKm != null) {
    isTimeDriven = false;
    ratio = ratioKm;
  } else {
    isTimeDriven = true;
    ratio = ratioTime!;
  }

  final ItemStatus status;
  if (ratio <= 0) {
    status = ItemStatus.overdue;
  } else if (ratio <= AppThresholds.warnRatio ||
      (remKm != null && remKm <= AppThresholds.warnRemainingKm)) {
    status = ItemStatus.warn;
  } else {
    status = ItemStatus.ok;
  }

  return RemainingLifeResult(
    status: status,
    ratio: ratio.clamp(0.0, 1.0),
    remainingKm: remKm,
    remainingDays: remDays,
    isTimeDriven: isTimeDriven,
  );
}

DateTime _addMonths(DateTime date, int months) {
  final totalMonths = date.year * 12 + (date.month - 1) + months;
  final year = totalMonths ~/ 12;
  final month = totalMonths % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, date.day.clamp(1, lastDay));
}
