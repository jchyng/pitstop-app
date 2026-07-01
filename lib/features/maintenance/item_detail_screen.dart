import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/format.dart';
import '../../core/utils/snackbar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/form_widgets.dart';
import '../../domain/logic/remaining_life.dart';
import '../../providers.dart';

// ─── 진입점 ───────────────────────────────────────────────────

class ItemDetailScreen extends ConsumerWidget {
  final int specId;
  final int vehicleId;
  final bool autoOpenForm;
  final MaintenanceRecord? autoOpenRecord;

  const ItemDetailScreen({
    super.key,
    required this.specId,
    required this.vehicleId,
    this.autoOpenForm = false,
    this.autoOpenRecord,
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
        return _DetailBody(
          spec: spec,
          vehicleId: vehicleId,
          autoOpenForm: autoOpenForm,
          autoOpenRecord: autoOpenRecord,
        );
      },
    );
  }
}

// ─── 본문 ─────────────────────────────────────────────────────

class _DetailBody extends ConsumerStatefulWidget {
  final ItemSpec spec;
  final int vehicleId;
  final bool autoOpenForm;
  final MaintenanceRecord? autoOpenRecord;

  const _DetailBody({
    required this.spec,
    required this.vehicleId,
    this.autoOpenForm = false,
    this.autoOpenRecord,
  });

  @override
  ConsumerState<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends ConsumerState<_DetailBody> {
  @override
  void initState() {
    super.initState();
    if (widget.autoOpenForm || widget.autoOpenRecord != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openForm(context, widget.spec, widget.autoOpenRecord);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    final vehicleId = widget.vehicleId;

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
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPaddingH, 14, AppSpacing.screenPaddingH, 0),
              child: Row(
                children: [
                  _NavBtn(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          spec.name,
                          style: AppText.sectionHeader,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (spec.subtitleKo != null &&
                            spec.subtitleKo!.isNotEmpty)
                          Text(
                            spec.subtitleKo!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                              fontFamily: AppText.fontFamily,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _NavBtn(
                    icon: Icons.more_horiz_rounded,
                    onTap: () => _showSpecInfo(context, spec),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 스크롤 영역
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // 상태 카드
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPaddingH,
                          14,
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
                          28,
                          AppSpacing.screenPaddingH,
                          14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('교체 이력', style: AppText.sectionHeader),
                          _AddBtn(
                            onTap: () => _openForm(context, spec, null),
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
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 48),
                              child: EmptyState(
                                icon: Icons.history_rounded,
                                title: '교체 기록이 없습니다',
                                description: '+ 추가를 눌러 첫 기록을 남겨보세요',
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                                AppSpacing.screenPaddingH,
                                0,
                                AppSpacing.screenPaddingH,
                                32),
                            sliver: SliverList.separated(
                              itemCount: records.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox.shrink(),
                              itemBuilder: (_, i) => _RecordTile(
                                record: records[i],
                                isFirst: i == 0,
                                isLast: i == records.length - 1,
                                onEdit: () =>
                                    _openForm(context, spec, records[i]),
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

    final vehicle = ref.read(vehiclesProvider).valueOrNull
        ?.where((v) => v.id == widget.vehicleId)
        .firstOrNull;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecordFormSheet(
        existing: existing,
        initialAmount: initialAmount,
        behavior: spec.behavior,
        currentOdometer: vehicle?.currentOdometer,
        onSave: (type, date, odometer, amount, place, memo) async {
          final db = ref.read(appDatabaseProvider);
          if (existing == null) {
            await db.addRecord(
              vehicleId: widget.vehicleId,
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
          _invalidate();
        },
        onDelete: existing == null
            ? null
            : () async {
                final db = ref.read(appDatabaseProvider);
                await db.deleteRecord(existing);
                _invalidate();
              },
      ),
    );
  }

  void _showSpecInfo(BuildContext context, ItemSpec spec) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SpecInfoSheet(spec: spec),
    );
  }

  void _invalidate() {
    ref.invalidate(itemSpecProvider(widget.spec.id));
    ref.invalidate(maintenanceRecordsProvider(widget.spec.id));
    ref.invalidate(sortedItemStatusProvider(widget.vehicleId));
    ref.invalidate(allMaintenanceRecordsProvider(widget.vehicleId));
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
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
                letterSpacing: 0.04,
                fontFamily: AppText.fontFamily,
              )),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              remainText,
              style: AppText.remainHero.copyWith(color: remainColor),
            ),
          ),
          const SizedBox(height: 16),
          // 게이지
          ClipRRect(
            borderRadius: AppRadius.gauge,
            child: Container(
              height: 5,
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
          const SizedBox(height: 18),
          const Divider(height: 1, color: AppColors.hairline),
          const SizedBox(height: 18),
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
          const SizedBox(height: 16),
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
                      ? fmtDateFull(spec.lastReplacedDate!)
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
                fontSize: 11,
                fontWeight: FontWeight.w500,
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


// ─── 타임라인 이력 행 ──────────────────────────────────────────

class _RecordTile extends StatefulWidget {
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
  State<_RecordTile> createState() => _RecordTileState();
}

class _RecordTileState extends State<_RecordTile> {
  bool _memoExpanded = false;

  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    final hasMemo = record.memo != null && record.memo!.isNotEmpty;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타임라인 레일
          SizedBox(
            width: 22,
            child: Column(
              children: [
                const SizedBox(height: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isFirst
                        ? AppColors.accent
                        : AppColors.textTertiary,
                    boxShadow: widget.isFirst
                        ? [
                            BoxShadow(
                              color: AppColors.accentBg,
                              blurRadius: 0,
                              spreadRadius: 3,
                            )
                          ]
                        : null,
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: AppColors.hairline,
                      margin: const EdgeInsets.only(top: 5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 카드
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.innerCard,
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 편집 탭 영역 (날짜·주행거리·장소) ──────────
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onEdit,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.cardPaddingH,
                        14,
                        AppSpacing.cardPaddingH,
                        hasMemo ? 12 : 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(fmtDateFull(record.date),
                                  style: AppText.item),
                              const Icon(Icons.chevron_right_rounded,
                                  size: 18, color: AppColors.textTertiary),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${fmtKm(record.odometer)} km · ${_typeLabel(record.type)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontFamily: AppText.fontFamily,
                            ),
                          ),
                          if (record.place != null &&
                              record.place!.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 12, color: AppColors.textTertiary),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    record.place!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textTertiary,
                                      fontFamily: AppText.fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // ── 메모 토글 영역 ───────────────────────────
                  if (hasMemo) ...[
                    const Divider(height: 1, color: AppColors.hairline),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () =>
                          setState(() => _memoExpanded = !_memoExpanded),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.cardPaddingH,
                            10,
                            AppSpacing.cardPaddingH,
                            10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                record.memo!,
                                maxLines: _memoExpanded ? null : 1,
                                overflow: _memoExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textTertiary,
                                  height: 1.55,
                                  fontFamily: AppText.fontFamily,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              _memoExpanded
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              size: 16,
                              color: AppColors.textTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
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
  final String? behavior;
  final int? currentOdometer;
  final _OnSave onSave;
  final Future<void> Function()? onDelete;

  const _RecordFormSheet({
    this.existing,
    this.initialAmount,
    this.behavior,
    this.currentOdometer,
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

  List<String> get _segmentOptions => switch (widget.behavior) {
        'replace_only' => const ['교체', '보충'],
        'inspect_only' => const ['점검', '보충'],
        _ => const ['교체', '점검', '보충'],
      };

  List<String> get _segmentValues => switch (widget.behavior) {
        'replace_only' => const ['replace', 'refill'],
        'inspect_only' => const ['inspect', 'refill'],
        _ => const ['replace', 'inspect', 'refill'],
      };

  @override
  void initState() {
    super.initState();
    final e = widget.existing;

    // behavior에 따라 유효한 타입으로 초기값 결정
    final availableValues = _segmentValues;
    final rawType =
        e?.type ?? (widget.behavior == 'inspect_only' ? 'inspect' : 'replace');
    _type =
        availableValues.contains(rawType) ? rawType : availableValues.first;

    _date = e?.date ?? DateTime.now();

    // 신규 추가 시 현재 차량 주행거리를 기본값으로 채움
    final defaultOdo = e != null
        ? fmtKm(e.odometer)
        : (widget.currentOdometer != null && widget.currentOdometer! > 0
            ? fmtKm(widget.currentOdometer!)
            : '');
    _odometerCtrl = TextEditingController(text: defaultOdo);
    _amountCtrl = TextEditingController(
      text: widget.initialAmount != null ? fmtKrw(widget.initialAmount!) : '',
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
    final odometerText = _odometerCtrl.text.trim().replaceAll(',', '');
    if (odometerText.isEmpty) {
      showAppSnackBar(context, '주행거리를 입력해주세요');
      return;
    }
    final odometer = int.tryParse(odometerText);
    if (odometer == null || odometer <= 0) {
      showAppSnackBar(context, '주행거리가 올바르지 않습니다');
      return;
    }

    final amountText = _amountCtrl.text.trim().replaceAll(',', '');
    final amount = amountText.isEmpty ? null : int.tryParse(amountText);

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
      if (mounted) showAppSnackBar(context, '저장 실패: $e');
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
        if (mounted) showAppSnackBar(context, '삭제 실패: $e');
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
      padding: EdgeInsets.fromLTRB(22, 14, 22, 24 + bottom),
      child: Column(
        children: [
          // 그래버
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
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
          const SizedBox(height: 6),
          // 폼
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 작업 유형
                  FormLabel('작업 유형'),
                  const SizedBox(height: 8),
                  _SegmentControl(
                    options: _segmentOptions,
                    values: _segmentValues,
                    selected: _type,
                    onChanged: (v) => setState(() => _type = v),
                  ),
                  // 날짜
                  FormLabel('날짜'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDate,
                    child: FormInputDecor(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            fmtDateFull(_date),
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
                  FormLabel('주행거리 (km)'),
                  const SizedBox(height: 8),
                  FormInputDecor(
                    child: TextField(
                      controller: _odometerCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ThousandsInputFormatter()],
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontFamily: AppText.fontFamily,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: '예: 44,421',
                        hintStyle: TextStyle(
                            color: AppColors.textTertiary, fontSize: 15),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  // 비용
                  FormLabel('비용 (원, 선택)'),
                  const SizedBox(height: 8),
                  FormInputDecor(
                    child: TextField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ThousandsInputFormatter()],
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontFamily: AppText.fontFamily,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: '예: 95,000',
                        hintStyle: TextStyle(
                            color: AppColors.textTertiary, fontSize: 15),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  // 장소
                  FormLabel('정비소 · 장소 (선택)'),
                  const SizedBox(height: 8),
                  FormInputDecor(
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
                  FormLabel('메모 (선택)'),
                  const SizedBox(height: 8),
                  FormInputDecor(
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
                  const SizedBox(height: 24),
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
                              borderRadius: AppRadius.button,
                            ),
                            child: TextButton(
                              onPressed: _save,
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.button),
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
                    const SizedBox(height: 10),
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
                  const SizedBox(height: 8),
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
          borderRadius: AppRadius.button,
        ),
        child: const Row(
          children: [
            Icon(Icons.add_rounded, size: 15, color: AppColors.accent),
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
        borderRadius: AppRadius.button,
      ),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(values[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: selected == values[i]
                        ? AppColors.accentBg
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
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

// ─── 소모품 정보 바텀시트 ─────────────────────────────────────

class _SpecInfoSheet extends StatelessWidget {
  final ItemSpec spec;
  const _SpecInfoSheet({required this.spec});

  @override
  Widget build(BuildContext context) {
    final behaviorLabel = switch (spec.behavior) {
      'replace_only' => '교체만',
      'inspect_only' => '점검만',
      'both' => '교체 · 점검',
      _ => null,
    };

    final rows = <(String, String)>[
      if (spec.note != null && spec.note!.isNotEmpty) ('참고사항', spec.note!),
      if (spec.severeIntervalKm != null)
        ('가혹 조건 주기', '${fmtKm(spec.severeIntervalKm!)} km'),
      if (behaviorLabel != null) ('작업 유형', behaviorLabel),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadius.bottomSheet,
      ),
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 그래버
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(40),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(spec.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                fontFamily: AppText.fontFamily,
              )),
          const SizedBox(height: 20),
          if (rows.isEmpty)
            const Text('추가 정보 없음',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                  fontFamily: AppText.fontFamily,
                ))
          else
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.innerCard,
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < rows.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(rows[i].$1,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textTertiary,
                                  fontFamily: AppText.fontFamily,
                                )),
                          ),
                          Expanded(
                            child: Text(rows[i].$2,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                  fontFamily: AppText.fontFamily,
                                  height: 1.5,
                                )),
                          ),
                        ],
                      ),
                    ),
                    if (i < rows.length - 1)
                      const Divider(height: 1, color: AppColors.hairline),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── 유틸 ─────────────────────────────────────────────────────

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
