import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/empty_state.dart';
import '../../providers.dart';

// ─── 카테고리 정의 ────────────────────────────────────────────

const _kCategories = [
  (key: 'fuel', label: '주유', color: AppColors.accent, bg: AppColors.accentBg),
  (key: 'maintenance', label: '정비·소모품', color: AppColors.teal, bg: AppColors.tealBg),
  (key: 'insurance_tax', label: '보험·세금', color: AppColors.purple, bg: AppColors.purpleBg),
  (key: 'parking_toll', label: '주차·통행', color: AppColors.amber, bg: AppColors.amberBg),
  (key: 'etc', label: '기타', color: AppColors.textTertiary, bg: AppColors.chip),
];

({String label, Color color, Color bg}) _catMeta(String key) {
  for (final c in _kCategories) {
    if (c.key == key) return (label: c.label, color: c.color, bg: c.bg);
  }
  return (label: '기타', color: AppColors.textTertiary, bg: AppColors.chip);
}

IconData _catIcon(String key) => switch (key) {
      'fuel' => Icons.local_gas_station_outlined,
      'maintenance' => Icons.build_outlined,
      'insurance_tax' => Icons.receipt_long_outlined,
      'parking_toll' => Icons.toll_outlined,
      _ => Icons.more_horiz_rounded,
    };

// ─── 진입점 ───────────────────────────────────────────────────

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  void _prevMonth() {
    setState(() {
      if (_month == 1) {
        _year--;
        _month = 12;
      } else {
        _month--;
      }
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    if (_year == now.year && _month == now.month) return;
    setState(() {
      if (_month == 12) {
        _year++;
        _month = 1;
      } else {
        _month++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return vehiclesAsync.when(
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
      data: (vehicles) {
        if (vehicles.isEmpty) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: Text('차량을 먼저 등록해주세요',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          );
        }
        final vehicleId = vehicles.first.id;
        return _ExpenseBody(
          vehicleId: vehicleId,
          year: _year,
          month: _month,
          onPrevMonth: _prevMonth,
          onNextMonth: _nextMonth,
        );
      },
    );
  }
}

// ─── 본문 ─────────────────────────────────────────────────────

class _ExpenseBody extends ConsumerWidget {
  final int vehicleId;
  final int year;
  final int month;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const _ExpenseBody({
    required this.vehicleId,
    required this.year,
    required this.month,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  void _openAddForm(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ExpenseFormSheet(
        initialYear: year,
        initialMonth: month,
        onSave: (category, title, date, amount, place) async {
          final db = ref.read(appDatabaseProvider);
          await db.addExpenseManually(
            vehicleId: vehicleId,
            category: category,
            title: title,
            date: date,
            amount: amount,
            place: place,
          );
          ref.invalidate(monthlyExpensesProvider(vehicleId, date.year, date.month));
          ref.invalidate(monthlySummaryProvider(vehicleId, date.year, date.month));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(monthlySummaryProvider(vehicleId, year, month));
    final expensesAsync = ref.watch(monthlyExpensesProvider(vehicleId, year, month));
    final now = DateTime.now();
    final isCurrentMonth = year == now.year && month == now.month;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── 상단 헤더 ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 24, AppSpacing.screenPaddingH, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('가계부', style: AppText.h1),
                    _MonthSelector(
                      year: year,
                      month: month,
                      canGoNext: !isCurrentMonth,
                      onPrev: onPrevMonth,
                      onNext: onNextMonth,
                    ),
                  ],
                ),
              ),
            ),

            // ── 요약 카드 ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 16, AppSpacing.screenPaddingH, 0),
                child: summaryAsync.when(
                  loading: () => const _CardShimmer(height: 160),
                  error: (e, _) => _ErrorCard(message: '$e'),
                  data: (s) => _SummaryCard(summary: s),
                ),
              ),
            ),

            // ── 도넛 카드 ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 12, AppSpacing.screenPaddingH, 0),
                child: summaryAsync.when(
                  loading: () => const _CardShimmer(height: 160),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (s) => s.total == 0
                      ? const SizedBox.shrink()
                      : _DonutCard(summary: s),
                ),
              ),
            ),

            // ── 내역 헤더 ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 28, AppSpacing.screenPaddingH, 8),
                child: Row(
                  children: [
                    const Text('내역', style: AppText.sectionHeader),
                    const SizedBox(width: 8),
                    expensesAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                      data: (list) => Text(
                        '${list.length}건',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textTertiary,
                          fontFamily: AppText.fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 내역 목록 ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, 0),
                child: expensesAsync.when(
                  loading: () => const _CardShimmer(height: 200),
                  error: (e, _) => _ErrorCard(message: '$e'),
                  data: (list) => list.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadius.card,
                            border: Border.all(color: AppColors.hairline),
                          ),
                          child: const EmptyState(
                            icon: Icons.account_balance_wallet_outlined,
                            title: '이번 달 지출 내역이 없습니다',
                            description: '+ 버튼을 눌러 지출을 추가해보세요',
                          ),
                        )
                      : _ExpenseListCard(
                          expenses: list,
                          onDelete: (id) async {
                            await ref.read(appDatabaseProvider).deleteExpense(id);
                            ref.invalidate(
                                monthlyExpensesProvider(vehicleId, year, month));
                            ref.invalidate(
                                monthlySummaryProvider(vehicleId, year, month));
                          },
                        ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddForm(context, ref),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.accent, AppColors.accent2],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x804FB0F5),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

// ─── 월 선택기 ────────────────────────────────────────────────

class _MonthSelector extends StatelessWidget {
  final int year;
  final int month;
  final bool canGoNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthSelector({
    required this.year,
    required this.month,
    required this.canGoNext,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.chip,
        borderRadius: AppRadius.chipShape,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ArrowBtn(icon: Icons.chevron_left_rounded, onTap: onPrev),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '$year년 $month월',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontFamily: AppText.fontFamily,
              ),
            ),
          ),
          _ArrowBtn(
            icon: Icons.chevron_right_rounded,
            onTap: canGoNext ? onNext : null,
          ),
        ],
      ),
    );
  }
}

class _ArrowBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _ArrowBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null
              ? AppColors.textTertiary.withAlpha(80)
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}

// ─── 요약 카드 ────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final ExpenseSummaryData summary;
  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final total = summary.total;
    final prev = summary.prevTotal;
    final km = summary.monthlyKm;
    final perKm = (km != null && km > 0 && total > 0)
        ? (total / km).round()
        : null;

    // 전달 대비
    final hasPrev = prev > 0;
    final diff = total - prev;
    final pct = hasPrev ? (diff / prev * 100).round() : 0;

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
          const Text('이번 달 총 지출',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
                letterSpacing: 0.04,
                fontFamily: AppText.fontFamily,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₩${fmtKrw(total)}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.72,
                  fontFeatures: [FontFeature.tabularFigures()],
                  fontFamily: AppText.fontFamily,
                  height: 1.0,
                ),
              ),
            ],
          ),
          if (hasPrev) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  diff > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  size: 14,
                  color: diff > 0 ? AppColors.amber : AppColors.teal,
                ),
                const SizedBox(width: 4),
                Text(
                  '지난달 ₩${fmtKrw(prev)} · ${diff > 0 ? '+' : ''}$pct%',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontFamily: AppText.fontFamily,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.hairline),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniCell(
                  label: '이번 달 주행',
                  value: km != null ? '${fmtKrw(km)} km' : '—',
                ),
              ),
              Expanded(
                child: _MiniCell(
                  label: 'km당 유지비',
                  value: perKm != null ? '₩${fmtKrw(perKm)}' : '—',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniCell extends StatelessWidget {
  final String label;
  final String value;
  const _MiniCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
              fontFamily: AppText.fontFamily,
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              fontFamily: AppText.fontFamily,
              fontFeatures: [FontFeature.tabularFigures()],
            )),
      ],
    );
  }
}

// ─── 도넛 카드 ────────────────────────────────────────────────

class _DonutCard extends StatelessWidget {
  final ExpenseSummaryData summary;
  const _DonutCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final total = summary.total;

    // 카테고리 순서 고정, 금액 있는 것만 표시
    final visible = _kCategories
        .where((c) => (summary.byCategory[c.key] ?? 0) > 0)
        .toList();

    final sections = visible
        .map((c) => PieChartSectionData(
              value: summary.byCategory[c.key]!.toDouble(),
              color: c.color,
              radius: 14,
              showTitle: false,
            ))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.hairline),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPaddingV),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 도넛
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 42,
                    sectionsSpace: 3,
                    startDegreeOffset: -90,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '₩${fmtKrw(total)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        fontFeatures: [FontFeature.tabularFigures()],
                        fontFamily: AppText.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text('총 지출',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                          fontFamily: AppText.fontFamily,
                        )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // 범례
          Expanded(
            child: Column(
              children: visible.map((c) {
                final amount = summary.byCategory[c.key]!;
                final pct = (amount / total * 100).round();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: c.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(c.label,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontFamily: AppText.fontFamily,
                            )),
                      ),
                      Text(
                        fmtKrw(amount),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          fontFeatures: [FontFeature.tabularFigures()],
                          fontFamily: AppText.fontFamily,
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 28,
                        child: Text(
                          '$pct%',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                            fontFamily: AppText.fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 내역 카드 목록 ───────────────────────────────────────────

class _ExpenseListCard extends StatelessWidget {
  final List<Expense> expenses;
  final Future<void> Function(int id) onDelete;

  const _ExpenseListCard({required this.expenses, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.hairline),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPaddingH, vertical: 4),
      child: Column(
        children: [
          for (var i = 0; i < expenses.length; i++) ...[
            _ExpenseRow(expense: expenses[i], onDelete: onDelete),
            if (i < expenses.length - 1)
              const Divider(height: 1, color: AppColors.hairline),
          ],
        ],
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  final Expense expense;
  final Future<void> Function(int id) onDelete;

  const _ExpenseRow({required this.expense, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final meta = _catMeta(expense.category);
    final icon = _catIcon(expense.category);
    final isAuto = expense.source == 'auto';

    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.redBg,
        child: const Icon(Icons.delete_outline_rounded,
            color: AppColors.red, size: 22),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: AppColors.surface2,
                title: const Text('내역 삭제',
                    style: TextStyle(color: AppColors.textPrimary)),
                content: const Text('이 지출 내역을 삭제하시겠어요?',
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
            ) ??
            false;
      },
      onDismissed: (_) => onDelete(expense.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            // 아이콘 칩
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: meta.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: meta.color),
            ),
            const SizedBox(width: 12),
            // 제목·부제
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          expense.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            fontFamily: AppText.fontFamily,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isAuto) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bolt_rounded,
                                  size: 11, color: AppColors.accent),
                              SizedBox(width: 2),
                              Text('자동',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.accent,
                                    fontFamily: AppText.fontFamily,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _buildSubtitle(expense),
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
            const SizedBox(width: 12),
            // 금액
            Text(
              '₩${fmtKrw(expense.amount)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                fontFeatures: [FontFeature.tabularFigures()],
                fontFamily: AppText.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle(Expense expense) {
    final parts = <String>[];
    if (expense.place != null && expense.place!.isNotEmpty) {
      parts.add(expense.place!);
    }
    parts.add(fmtDateShort(expense.date));
    return parts.join(' · ');
  }
}

// ─── 지출 추가 바텀시트 ───────────────────────────────────────

typedef _OnExpenseSave = Future<void> Function(
  String category,
  String title,
  DateTime date,
  int amount,
  String? place,
);

class _ExpenseFormSheet extends StatefulWidget {
  final int initialYear;
  final int initialMonth;
  final _OnExpenseSave onSave;

  const _ExpenseFormSheet({
    required this.initialYear,
    required this.initialMonth,
    required this.onSave,
  });

  @override
  State<_ExpenseFormSheet> createState() => _ExpenseFormSheetState();
}

class _ExpenseFormSheetState extends State<_ExpenseFormSheet> {
  String _category = 'fuel';
  late DateTime _date;
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _placeCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // 현재 선택 월이 이번달이면 오늘, 아니면 해당 월 말일
    if (widget.initialYear == now.year && widget.initialMonth == now.month) {
      _date = now;
    } else {
      _date = DateTime(widget.initialYear, widget.initialMonth + 1, 0);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _placeCtrl.dispose();
    super.dispose();
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

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('항목명을 입력해주세요')));
      return;
    }
    final amountText = _amountCtrl.text.trim().replaceAll(',', '');
    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('금액을 올바르게 입력해주세요')));
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.onSave(
        _category,
        title,
        _date,
        amount,
        _placeCtrl.text.trim().isEmpty ? null : _placeCtrl.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const Text('지출 추가',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    fontFamily: AppText.fontFamily,
                  )),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.chip,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 20, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리
                  _FormLabel('카테고리'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _kCategories
                        .map((c) => _CatChip(
                              label: c.label,
                              color: c.color,
                              bg: c.bg,
                              selected: _category == c.key,
                              onTap: () =>
                                  setState(() => _category = c.key),
                            ))
                        .toList(),
                  ),
                  // 항목명
                  _FormLabel('항목명'),
                  const SizedBox(height: 8),
                  _FormField(
                    controller: _titleCtrl,
                    hint: '예: 주유, 엔진오일 교체',
                  ),
                  // 날짜
                  _FormLabel('날짜'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDate,
                    child: _FormDecor(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(fmtDateFull(_date),
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textPrimary,
                                fontFamily: AppText.fontFamily,
                              )),
                          const Icon(Icons.calendar_month_outlined,
                              size: 18, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ),
                  // 금액
                  _FormLabel('금액 (원)'),
                  const SizedBox(height: 8),
                  _FormField(
                    controller: _amountCtrl,
                    hint: '예: 78000',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    numericFeature: true,
                  ),
                  // 장소
                  _FormLabel('장소 (선택)'),
                  const SizedBox(height: 8),
                  _FormField(
                    controller: _placeCtrl,
                    hint: '예: GS칼텍스 강남',
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
                              child: const Text('저장',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontFamily: AppText.fontFamily,
                                  )),
                            ),
                          ),
                  ),
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

// ─── 폼 공용 위젯 ─────────────────────────────────────────────

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 0),
      child: Text(text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
            fontFamily: AppText.fontFamily,
          )),
    );
  }
}

class _FormDecor extends StatelessWidget {
  final Widget child;
  const _FormDecor({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        border: Border.all(color: AppColors.hairline),
        borderRadius: AppRadius.button,
      ),
      child: child,
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool numericFeature;

  const _FormField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.numericFeature = false,
  });

  @override
  Widget build(BuildContext context) {
    return _FormDecor(
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
          fontFamily: AppText.fontFamily,
          fontFeatures:
              numericFeature ? const [FontFeature.tabularFigures()] : null,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
              color: AppColors.textTertiary, fontSize: 15),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _CatChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  final bool selected;
  final VoidCallback onTap;

  const _CatChip({
    required this.label,
    required this.color,
    required this.bg,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? bg : Colors.transparent,
          border: Border.all(
            color: selected ? color : AppColors.hairline,
          ),
          borderRadius: AppRadius.chipShape,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            color: selected ? color : AppColors.textTertiary,
            fontFamily: AppText.fontFamily,
          ),
        ),
      ),
    );
  }
}

// ─── 보조 위젯 ────────────────────────────────────────────────

class _CardShimmer extends StatelessWidget {
  final double height;
  const _CardShimmer({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.hairline),
      ),
      child: const Center(
          child: CircularProgressIndicator(color: AppColors.accent)),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.hairline),
      ),
      child: Text('오류: $message',
          style: const TextStyle(color: AppColors.textSecondary)),
    );
  }
}
