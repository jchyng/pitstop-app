import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/format.dart';
import '../../domain/logic/remaining_life.dart';
import '../../providers.dart';

// ─── 진입점 ───────────────────────────────────────────────────

class ItemDetailScreen extends ConsumerWidget {
  final int specId;
  final int vehicleId;

  const ItemDetailScreen({
    super.key,
    required this.specId,
    required this.vehicleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specAsync = ref.watch(itemSpecProvider(specId));

    return specAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Text('오류: $e',
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ),
      data: (spec) {
        if (spec == null) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: Text('항목을 찾을 수 없습니다.',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          );
        }
        return _DetailBody(spec: spec, vehicleId: vehicleId);
      },
    );
  }
}

// ─── 본문 ─────────────────────────────────────────────────────

class _DetailBody extends ConsumerWidget {
  final ItemSpec spec;
  final int vehicleId;

  const _DetailBody({required this.spec, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final recordsAsync = ref.watch(maintenanceRecordsProvider(spec.id));

    final vehicle = vehiclesAsync.valueOrNull
        ?.where((v) => v.id == vehicleId)
        .firstOrNull;
    final result = vehicle != null
        ? calculateRemainingLife(spec, vehicle.currentOdometer, DateTime.now())
        : const RemainingLifeResult(status: ItemStatus.unknown);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 네비바
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Row(
                children: [
                  _NavBtn(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      spec.name,
                      style: AppText.sectionHeader,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const _NavBtn(icon: Icons.more_horiz_rounded),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // 스크롤 영역
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // 상태 카드
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPaddingH,
                          16,
                          AppSpacing.screenPaddingH,
                          0),
                      child: _StatusCard(spec: spec, result: result),
                    ),
                  ),

                  // 이력 헤더
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPaddingH,
                          30,
                          AppSpacing.screenPaddingH,
                          16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('교체 이력', style: AppText.sectionHeader),
                          _AddBtn(
                            onTap: () => _openForm(context, ref, spec, null),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 이력 타임라인
                  recordsAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.accent),
                        ),
                      ),
                    ),
                    error: (e, _) => SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('오류: $e',
                            style: const TextStyle(
                                color: AppColors.textSecondary)),
                      ),
                    ),
                    data: (records) => records.isEmpty
                        ? const SliverToBoxAdapter(
                            child: _EmptyRecords(),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                                AppSpacing.screenPaddingH,
                                0,
                                AppSpacing.screenPaddingH,
                                32),
                            sliver: SliverList.separated(
                              itemCount: records.length,
                              separatorBuilder: (_, a) =>
                                  const SizedBox.shrink(),
                              itemBuilder: (_, i) => _RecordTile(
                                record: records[i],
                                isFirst: i == 0,
                                isLast: i == records.length - 1,
                                onEdit: () =>
                                    _openForm(context, ref, spec, records[i]),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref,
    ItemSpec spec,
    MaintenanceRecord? existing,
  ) async {
    int? initialAmount;
    if (existing?.expenseId != null) {
      final db = ref.read(appDatabaseProvider);
      final expense = await db.getExpense(existing!.expenseId!);
      initialAmount = expense?.amount;
    }
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecordFormSheet(
        existing: existing,
        initialAmount: initialAmount,
        onSave: (type, date, odometer, amount, place, memo) async {
          final db = ref.read(appDatabaseProvider);
          if (existing == null) {
            await db.addRecord(
              vehicleId: vehicleId,
              specId: spec.id,
              specName: spec.name,
              type: type,
              date: date,
              odometer: odometer,
              amount: amount,
              place: place,
              memo: memo,
            );
          } else {
            await db.updateRecord(
              existing: existing,
              specName: spec.name,
              type: type,
              date: date,
              odometer: odometer,
              amount: amount,
              place: place,
              memo: memo,
            );
          }
          _invalidate(ref);
        },
        onDelete: existing == null
            ? null
            : () async {
                final db = ref.read(appDatabaseProvider);
                await db.deleteRecord(existing);
                _invalidate(ref);
              },
      ),
    );
  }

  void _invalidate(WidgetRef ref) {
    ref.invalidate(itemSpecProvider(spec.id));
    ref.invalidate(maintenanceRecordsProvider(spec.id));
    ref.invalidate(sortedItemStatusProvider(vehicleId));
    ref.invalidate(vehiclesProvider);
  }
}

// ─── 상태 카드 ────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final ItemSpec spec;
  final RemainingLifeResult result;

  const _StatusCard({required this.spec, required this.result});

  @override
  Widget build(BuildContext context) {
    final (fillColor, fillGradient) = _gaugeStyle(result.status);
    final remainText = _remainText(result);
    final remainColor = _remainColor(result.status);
    final nextDueOdometer = spec.lastReplacedOdometer != null &&
            spec.intervalKm != null
        ? spec.lastReplacedOdometer! + spec.intervalKm!
        : null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.hairline),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPaddingV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('다음 교체까지',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
                letterSpacing: 0.03,
                fontFamily: AppText.fontFamily,
              )),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                remainText,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w500,
                  color: remainColor,
                  letterSpacing: -0.68,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontFamily: AppText.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // 게이지
          ClipRRect(
            borderRadius: AppRadius.gauge,
            child: Container(
              height: 6,
              color: const Color(0x0FFFFFFF),
              alignment: Alignment.centerLeft,
              child: result.status == ItemStatus.unknown
                  ? const SizedBox.shrink()
                  : TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: result.ratio ?? 0),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (_, value, _) => FractionallySizedBox(
                        widthFactor: value,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: fillColor,
                            gradient: fillGradient,
                            borderRadius: AppRadius.gauge,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          // 메타 그리드
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.hairline),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _GridCell(
                  label: '마지막 교체',
                  value: spec.lastReplacedOdometer != null
                      ? '${fmtKm(spec.lastReplacedOdometer!)} km'
                      : '-',
                ),
              ),
              Expanded(
                child: _GridCell(
                  label: '다음 교체 예정',
                  value: nextDueOdometer != null
                      ? '${fmtKm(nextDueOdometer)} km'
                      : '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _GridCell(
                  label: '교체 주기',
                  value: _fmtInterval(spec.intervalKm, spec.intervalMonths),
                ),
              ),
              Expanded(
                child: _GridCell(
                  label: '마지막 교체일',
                  value: spec.lastReplacedDate != null
                      ? _fmtDate(spec.lastReplacedDate!)
                      : '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  (Color?, LinearGradient?) _gaugeStyle(ItemStatus s) => switch (s) {
        ItemStatus.ok => (
            null,
            const LinearGradient(colors: [AppColors.accent2, AppColors.accent])
          ),
        ItemStatus.warn => (AppColors.amber, null),
        ItemStatus.overdue => (AppColors.red, null),
        ItemStatus.unknown => (null, null),
      };

  Color _remainColor(ItemStatus s) => switch (s) {
        ItemStatus.ok => AppColors.textPrimary,
        ItemStatus.warn => AppColors.amber,
        ItemStatus.overdue => AppColors.red,
        ItemStatus.unknown => AppColors.textTertiary,
      };

  String _remainText(RemainingLifeResult r) {
    if (r.status == ItemStatus.unknown) return '이력 없음';
    if (r.isTimeDriven && r.remainingDays != null) {
      final d = r.remainingDays!;
      return d >= 0 ? 'D-$d' : 'D+${-d}';
    }
    if (r.remainingKm != null) {
      final km = r.remainingKm!;
      return km >= 0 ? '${fmtKm(km)} km 남음' : '${fmtKm(-km)} km 초과';
    }
    return '-';
  }
}

class _GridCell extends StatelessWidget {
  final String label;
  final String value;
  const _GridCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
                fontFamily: AppText.fontFamily)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              fontFamily: AppText.fontFamily,
              fontFeatures: [FontFeature.tabularFigures()],
            )),
      ],
    );
  }
}

// ─── 이력 없음 안내 ───────────────────────────────────────────

class _EmptyRecords extends StatelessWidget {
  const _EmptyRecords();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.history_rounded, size: 40, color: AppColors.textTertiary),
            const SizedBox(height: 12),
            const Text('교체 기록이 없습니다',
                style: TextStyle(
                    fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            const Text('+ 추가를 눌러 첫 기록을 남겨보세요',
                style: TextStyle(
                    fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }
}

// ─── 타임라인 이력 행 ──────────────────────────────────────────

class _RecordTile extends StatelessWidget {
  final MaintenanceRecord record;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onEdit;

  const _RecordTile({
    required this.record,
    required this.isFirst,
    required this.isLast,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 타임라인 레일
        SizedBox(
          width: 24,
          child: Column(
            children: [
              const SizedBox(height: 5),
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFirst ? AppColors.accent : AppColors.textTertiary,
                  boxShadow: isFirst
                      ? [
                          BoxShadow(
                            color: AppColors.accentBg,
                            blurRadius: 0,
                            spreadRadius: 4,
                          )
                        ]
                      : null,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 88,
                  color: AppColors.hairline,
                  margin: const EdgeInsets.only(top: 6),
                ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        // 카드
        Expanded(
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.innerCard,
                border: Border.all(color: AppColors.hairline),
              ),
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_fmtDate(record.date), style: AppText.item),
                      if (record.expenseId != null) // amount는 별도 로드 필요
                        const Icon(Icons.chevron_right_rounded,
                            size: 18, color: AppColors.textTertiary)
                      else
                        const Icon(Icons.chevron_right_rounded,
                            size: 18, color: AppColors.textTertiary),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${fmtKm(record.odometer)} km · ${_typeLabel(record.type)}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontFamily: AppText.fontFamily,
                    ),
                  ),
                  if (record.place != null && record.place!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            record.place!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textTertiary,
                              fontFamily: AppText.fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (record.memo != null && record.memo!.isNotEmpty) ...[
                    const SizedBox(height: 9),
                    const Divider(height: 1, color: AppColors.hairline),
                    const SizedBox(height: 9),
                    Text(
                      record.memo!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                        height: 1.55,
                        fontFamily: AppText.fontFamily,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── 기록 추가/수정 바텀시트 ───────────────────────────────────

typedef _OnSave = Future<void> Function(
  String type,
  DateTime date,
  int odometer,
  int? amount,
  String? place,
  String? memo,
);

class _RecordFormSheet extends StatefulWidget {
  final MaintenanceRecord? existing;
  final int? initialAmount;
  final _OnSave onSave;
  final Future<void> Function()? onDelete;

  const _RecordFormSheet({
    this.existing,
    this.initialAmount,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<_RecordFormSheet> createState() => _RecordFormSheetState();
}

class _RecordFormSheetState extends State<_RecordFormSheet> {
  late String _type;
  late DateTime _date;
  late TextEditingController _odometerCtrl;
  late TextEditingController _amountCtrl;
  late TextEditingController _placeCtrl;
  late TextEditingController _memoCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _type = e?.type ?? 'replace';
    _date = e?.date ?? DateTime.now();
    _odometerCtrl =
        TextEditingController(text: e != null ? '${e.odometer}' : '');
    _amountCtrl = TextEditingController(
      text: widget.initialAmount != null ? '${widget.initialAmount}' : '',
    );
    _placeCtrl = TextEditingController(text: e?.place ?? '');
    _memoCtrl = TextEditingController(text: e?.memo ?? '');
  }

  @override
  void dispose() {
    _odometerCtrl.dispose();
    _amountCtrl.dispose();
    _placeCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final odometerText = _odometerCtrl.text.trim();
    if (odometerText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('주행거리를 입력해주세요')),
      );
      return;
    }
    final odometer = int.tryParse(odometerText.replaceAll(',', ''));
    if (odometer == null || odometer <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('주행거리가 올바르지 않습니다')),
      );
      return;
    }

    final amountText = _amountCtrl.text.trim();
    final amount = amountText.isEmpty
        ? null
        : int.tryParse(amountText.replaceAll(',', ''));

    setState(() => _saving = true);
    try {
      await widget.onSave(
        _type,
        _date,
        odometer,
        amount,
        _placeCtrl.text.trim().isEmpty ? null : _placeCtrl.text.trim(),
        _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface2,
        title: const Text('기록 삭제',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('이 기록을 삭제하면 연결된 가계부 내역도 함께 삭제됩니다.',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('삭제',
                style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _saving = true);
      try {
        await widget.onDelete!();
        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('삭제 실패: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _saving = false);
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            surface: AppColors.surface2,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadius.bottomSheet,
      ),
      padding: EdgeInsets.fromLTRB(22, 14, 22, 26 + bottom),
      child: Column(
        children: [
          // 그래버
          Container(
            width: 38,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(46),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEdit ? '기록 수정' : '교체 기록 추가',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  fontFamily: AppText.fontFamily,
                ),
              ),
              _NavBtn(
                icon: Icons.close_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 폼
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 작업 유형
                  _FieldLabel('작업 유형'),
                  const SizedBox(height: 8),
                  _SegmentControl(
                    options: const ['교체', '점검', '보충'],
                    values: const ['replace', 'inspect', 'refill'],
                    selected: _type,
                    onChanged: (v) => setState(() => _type = v),
                  ),
                  // 날짜
                  _FieldLabel('날짜'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDate,
                    child: _InpDecor(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _fmtDate(_date),
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                              fontFamily: AppText.fontFamily,
                            ),
                          ),
                          const Icon(Icons.calendar_month_outlined,
                              size: 18, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ),
                  // 주행거리
                  _FieldLabel('주행거리 (km)'),
                  const SizedBox(height: 8),
                  _InpDecor(
                    child: TextField(
                      controller: _odometerCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontFamily: AppText.fontFamily,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: '예: 44421',
                        hintStyle: TextStyle(
                            color: AppColors.textTertiary, fontSize: 15),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  // 비용
                  _FieldLabel('비용 (원, 선택)'),
                  const SizedBox(height: 8),
                  _InpDecor(
                    child: TextField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontFamily: AppText.fontFamily,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: '예: 95000',
                        hintStyle: TextStyle(
                            color: AppColors.textTertiary, fontSize: 15),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  // 장소
                  _FieldLabel('정비소 · 장소 (선택)'),
                  const SizedBox(height: 8),
                  _InpDecor(
                    child: TextField(
                      controller: _placeCtrl,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontFamily: AppText.fontFamily,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: '예: 블루핸즈 강남점',
                        hintStyle: TextStyle(
                            color: AppColors.textTertiary, fontSize: 15),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  // 메모
                  _FieldLabel('메모 (선택)'),
                  const SizedBox(height: 8),
                  _InpDecor(
                    child: TextField(
                      controller: _memoCtrl,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontFamily: AppText.fontFamily,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: '예: 합성유 0W-20, 오일필터 동시 교체',
                        hintStyle: TextStyle(
                            color: AppColors.textTertiary, fontSize: 15),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  // 저장 버튼
                  SizedBox(
                    width: double.infinity,
                    child: _saving
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.accent))
                        : DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [AppColors.accent, AppColors.accent2],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextButton(
                              onPressed: _save,
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text(
                                '저장',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontFamily: AppText.fontFamily,
                                ),
                              ),
                            ),
                          ),
                  ),
                  // 삭제 버튼 (수정 모드만)
                  if (isEdit && widget.onDelete != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _saving ? null : _confirmDelete,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          '이 기록 삭제',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.red,
                            fontFamily: AppText.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 공용 작은 위젯 ────────────────────────────────────────────

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _NavBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.chip,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
    );
  }
}

class _AddBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AddBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.accentBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.add_rounded, size: 16, color: AppColors.accent),
            SizedBox(width: 4),
            Text('추가',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accent,
                  fontFamily: AppText.fontFamily,
                )),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 0),
      child: Text(text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
            fontFamily: AppText.fontFamily,
          )),
    );
  }
}

class _InpDecor extends StatelessWidget {
  final Widget child;
  const _InpDecor({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        border: Border.all(color: AppColors.hairline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _SegmentControl extends StatelessWidget {
  final List<String> options;
  final List<String> values;
  final String selected;
  final ValueChanged<String> onChanged;

  const _SegmentControl({
    required this.options,
    required this.values,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.chip,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(values[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected == values[i]
                        ? AppColors.accentBg
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    options[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected == values[i]
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: selected == values[i]
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontFamily: AppText.fontFamily,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── 유틸 ─────────────────────────────────────────────────────

String _fmtDate(DateTime d) =>
    '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

String _fmtInterval(int? km, int? months) {
  final parts = <String>[];
  if (km != null) parts.add('${fmtKm(km)} km');
  if (months != null) {
    parts.add(months % 12 == 0 ? '${months ~/ 12}년' : '$months개월');
  }
  return parts.isEmpty ? '-' : parts.join(' / ');
}

String _typeLabel(String type) => switch (type) {
      'replace' => '정기 교체',
      'inspect' => '점검',
      'refill' => '보충',
      _ => type,
    };
