import 'package:flutter_test/flutter_test.dart';
import 'package:pitstop/core/db/database.dart';
import 'package:pitstop/core/theme/tokens.dart';
import 'package:pitstop/domain/logic/remaining_life.dart';

// 테스트용 ItemSpec 팩토리
ItemSpec _spec({
  int id = 1,
  int vehicleId = 1,
  String key = 'test_item',
  String name = '테스트 항목',
  String category = 'test',
  int? intervalKm,
  int? intervalMonths,
  int? lastReplacedOdometer,
  DateTime? lastReplacedDate,
  bool isHidden = false,
}) =>
    ItemSpec(
      id: id,
      vehicleId: vehicleId,
      key: key,
      name: name,
      category: category,
      intervalKm: intervalKm,
      intervalMonths: intervalMonths,
      lastReplacedOdometer: lastReplacedOdometer,
      lastReplacedDate: lastReplacedDate,
      isHidden: isHidden,
    );

void main() {
  // 고정 기준일: 2026-06-08
  final today = DateTime(2026, 6, 8);

  group('이력 없음 (unknown)', () {
    test('lastReplacedOdometer·Date 모두 null → unknown', () {
      final spec = _spec(intervalKm: 10000, intervalMonths: 12);
      final r = calculateRemainingLife(spec, 50000, today);
      expect(r.status, ItemStatus.unknown);
      expect(r.ratio, isNull);
    });

    test('이력 있으나 interval 모두 null → unknown', () {
      final spec = _spec(
        lastReplacedOdometer: 40000,
        lastReplacedDate: DateTime(2025, 6, 1),
        // intervalKm, intervalMonths 모두 없음
      );
      final r = calculateRemainingLife(spec, 50000, today);
      expect(r.status, ItemStatus.unknown);
    });
  });

  group('거리 축만', () {
    test('ok — ratio 0.5', () {
      // last=40000, interval=10000, current=45000 → rem=5000, ratio=0.5
      final spec = _spec(
          intervalKm: 10000,
          lastReplacedOdometer: 40000);
      final r = calculateRemainingLife(spec, 45000, today);
      expect(r.status, ItemStatus.ok);
      expect(r.ratio, closeTo(0.5, 0.001));
      expect(r.remainingKm, 5000);
      expect(r.isTimeDriven, isFalse);
    });

    test('warn — remKm=800 (km 임계값)', () {
      // last=50000, interval=5000, current=54200 → rem=800
      final spec = _spec(intervalKm: 5000, lastReplacedOdometer: 50000);
      final r = calculateRemainingLife(spec, 54200, today);
      expect(r.status, ItemStatus.warn);
      expect(r.remainingKm, 800);
    });

    test('warn — ratio 0.10 (ratio 임계값)', () {
      // last=50000, interval=10000, current=59000 → rem=1000, ratio=0.1 ≤0.15
      final spec = _spec(intervalKm: 10000, lastReplacedOdometer: 50000);
      final r = calculateRemainingLife(spec, 59000, today);
      expect(r.status, ItemStatus.warn);
    });

    test('overdue — remKm 음수', () {
      // last=50000, interval=10000, current=61000 → rem=-1000
      final spec = _spec(intervalKm: 10000, lastReplacedOdometer: 50000);
      final r = calculateRemainingLife(spec, 61000, today);
      expect(r.status, ItemStatus.overdue);
      expect(r.ratio, 0.0);
      expect(r.remainingKm, -1000);
    });
  });

  group('시간 축만', () {
    test('ok — ratio 0.5 (6개월 주기, 3개월 지남)', () {
      // 3개월 전 교체, 6개월 주기 → remDays ≈ 91, ratio ≈ 0.5
      final spec = _spec(
          intervalMonths: 6,
          lastReplacedDate: DateTime(2026, 3, 8)); // 3개월 전
      final r = calculateRemainingLife(spec, 50000, today);
      expect(r.status, ItemStatus.ok);
      expect(r.isTimeDriven, isTrue);
      expect(r.remainingDays, greaterThan(0));
    });

    test('warn — ratio ≤ 0.15', () {
      // 24개월 주기, 23개월 지남 → remDays ≈ 30, ratio ≈ 0.041
      final spec = _spec(
          intervalMonths: 24,
          lastReplacedDate: DateTime(2024, 7, 8)); // ≈23.9개월 전
      final r = calculateRemainingLife(spec, 50000, today);
      expect(r.status, ItemStatus.warn);
      expect(r.isTimeDriven, isTrue);
    });

    test('overdue — 만료일 지남', () {
      // 12개월 주기, 14개월 전 교체
      final spec = _spec(
          intervalMonths: 12,
          lastReplacedDate: DateTime(2025, 4, 1));
      final r = calculateRemainingLife(spec, 50000, today);
      expect(r.status, ItemStatus.overdue);
      expect(r.remainingDays, lessThan(0));
    });
  });

  group('거리 + 시간 축 동시 존재', () {
    test('거리 축이 더 임박 → isTimeDriven=false', () {
      // km: last=50000, interval=10000, current=59500 → rem=500, ratio=0.05
      // time: 1개월 전, interval=12개월 → ratio≈0.917
      final spec = _spec(
        intervalKm: 10000,
        intervalMonths: 12,
        lastReplacedOdometer: 50000,
        lastReplacedDate: DateTime(2026, 5, 8), // 1개월 전
      );
      final r = calculateRemainingLife(spec, 59500, today);
      expect(r.isTimeDriven, isFalse);
      expect(r.status, ItemStatus.warn); // ratio=0.05 ≤ 0.15
      expect(r.remainingKm, 500);
    });

    test('시간 축이 더 임박 → isTimeDriven=true', () {
      // km: last=50000, interval=10000, current=51000 → rem=9000, ratio=0.9
      // time: 5달+20일 전, interval=6개월 → remDays≈10, ratio≈0.055
      final spec = _spec(
        intervalKm: 10000,
        intervalMonths: 6,
        lastReplacedOdometer: 50000,
        lastReplacedDate: DateTime(2025, 12, 19), // ≈5.6개월 전
      );
      final r = calculateRemainingLife(spec, 51000, today);
      expect(r.isTimeDriven, isTrue);
      expect(r.status, ItemStatus.warn); // ratio≈0.055 ≤ 0.15
    });
  });

  group('경계값', () {
    test('ratio 정확히 0.15 → warn', () {
      // last=50000, interval=10000, current=58500 → rem=1500, ratio=0.15
      final spec = _spec(intervalKm: 10000, lastReplacedOdometer: 50000);
      final r = calculateRemainingLife(spec, 58500, today);
      expect(r.status, ItemStatus.warn);
      expect(r.ratio, closeTo(AppThresholds.warnRatio, 0.0001));
    });

    test('ratio 0.16 → ok (ratio 임계값 초과)', () {
      // last=50000, interval=10000, current=58400 → rem=1600, ratio=0.16
      // 단 remKm=1600 > 1000 이므로 km 임계값도 통과
      final spec = _spec(intervalKm: 10000, lastReplacedOdometer: 50000);
      final r = calculateRemainingLife(spec, 58400, today);
      expect(r.status, ItemStatus.ok);
    });

    test('remKm 정확히 1000 → warn', () {
      // interval=5000, last=50000, current=54000 → rem=1000, ratio=0.2 >0.15
      final spec = _spec(intervalKm: 5000, lastReplacedOdometer: 50000);
      final r = calculateRemainingLife(spec, 54000, today);
      expect(r.status, ItemStatus.warn);
      expect(r.remainingKm, AppThresholds.warnRemainingKm);
    });

    test('remKm 1001 → ok (km 임계값 미달, ratio >0.15)', () {
      // interval=5000, last=50000, current=53999 → rem=1001, ratio=0.2002
      final spec = _spec(intervalKm: 5000, lastReplacedOdometer: 50000);
      final r = calculateRemainingLife(spec, 53999, today);
      expect(r.status, ItemStatus.ok);
      expect(r.remainingKm, 1001);
    });

    test('ratio=0 → overdue (정확히 만료)', () {
      // last=50000, interval=10000, current=60000 → rem=0, ratio=0
      final spec = _spec(intervalKm: 10000, lastReplacedOdometer: 50000);
      final r = calculateRemainingLife(spec, 60000, today);
      expect(r.status, ItemStatus.overdue);
      expect(r.ratio, 0.0);
    });
  });
}
