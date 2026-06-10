import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/tokens.dart';
import '../../core/db/database.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/odometer_sheet.dart';
import '../../domain/logic/remaining_life.dart';
import '../../providers.dart';
import '../maintenance/item_detail_screen.dart';

class GarageScreen extends ConsumerWidget {
  final VoidCallback? onNavigateToMore;
  const GarageScreen({super.key, this.onNavigateToMore});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initAsync = ref.watch(appInitProvider);

    return initAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Text('초기화 오류: $e',
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ),
      data: (_) => _GarageBody(onNavigateToMore: onNavigateToMore),
    );
  }
}

// ─── 본문 ────────────────────────────────────────────────────

class _GarageBody extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToMore;
  const _GarageBody({this.onNavigateToMore});

  @override
  ConsumerState<_GarageBody> createState() => _GarageBodyState();
}

class _GarageBodyState extends ConsumerState<_GarageBody> {
  bool _groupByCategory = false;

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
          slivers: [
            // 툴바
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 18, AppSpacing.screenPaddingH, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('내 차고',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                          letterSpacing: 0.05,
                          fontFamily: AppText.fontFamily,
                          fontWeight: FontWeight.w600,
                        )),
                    GestureDetector(
                      onTap: widget.onNavigateToMore,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.chip,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.settings_outlined,
                            size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 차량 히어로
            SliverToBoxAdapter(
              child: vehiclesAsync.when(
                loading: () => const SizedBox(height: 120),
                error: (_, _) => const SizedBox(height: 120),
                data: (vehicles) => vehicles.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.fromLTRB(
                            AppSpacing.screenPaddingH, 32,
                            AppSpacing.screenPaddingH, 0),
                        child: EmptyState(
                          icon: Icons.directions_car_outlined,
                          title: '차량을 등록해주세요',
                          description:
                              '카탈로그에서 내 차량을 선택하면\n소모품 현황이 자동으로 설정됩니다.',
                        ),
                      )
                    : _VehicleHero(vehicle: vehicles.first),
              ),
            ),

            // 소모품 현황 헤더
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 28, AppSpacing.screenPaddingH, 8),
                child: Row(
                  children: [
                    Text('소모품 현황',
                        style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    // 카테고리 그룹 토글
                    GestureDetector(
                      onTap: () =>
                          setState(() => _groupByCategory = !_groupByCategory),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: _groupByCategory
                              ? AppColors.accentBg
                              : AppColors.chip,
                          borderRadius: AppRadius.chipShape,
                          border: Border.all(
                            color: _groupByCategory
                                ? AppColors.accent
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.category_outlined,
                                size: 12,
                                color: _groupByCategory
                                    ? AppColors.accent
                                    : AppColors.textTertiary),
                            const SizedBox(width: 4),
                            Text(
                              '카테고리',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _groupByCategory
                                    ? AppColors.accent
                                    : AppColors.textTertiary,
                                fontFamily: AppText.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 더보기 이동 버튼
                    GestureDetector(
                      onTap: widget.onNavigateToMore,
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        child: Icon(Icons.chevron_right_rounded,
                            size: 18, color: AppColors.textTertiary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 소모품 카드
            SliverToBoxAdapter(
              child: vehiclesAsync.when(
                loading: () => const SizedBox(),
                error: (_, _) => const SizedBox(),
                data: (vehicles) => vehicles.isEmpty
                    ? const SizedBox()
                    : _ItemStatusCard(
                        vehicleId: vehicles.first.id,
                        groupByCategory: _groupByCategory,
                      ),
              ),
            ),

            // 하단 노트
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 12, AppSpacing.screenPaddingH, 24),
                child: Text(
                  '※ 주행 습관이나 도로 사정에 따라 실제 교체 시기가 다를 수 있습니다.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    height: 1.6,
                    fontFamily: AppText.fontFamily,
                  ),
                ),
              ),
            ),
          ],
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: IgnorePointer(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.bg.withAlpha(0), AppColors.bg],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 차량 히어로 ─────────────────────────────────────────────

class _VehicleHero extends ConsumerWidget {
  final Vehicle vehicle;
  const _VehicleHero({required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPaddingH, 24, AppSpacing.screenPaddingH, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vehicle.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (vehicle.trim != null) ...[
            const SizedBox(height: 3),
            Text(vehicle.trim!,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontFamily: AppText.fontFamily)),
          ],
          const SizedBox(height: 24),
          Text('총 주행거리',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
                letterSpacing: 0.04,
                fontFamily: AppText.fontFamily,
              )),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(fmtKm(vehicle.currentOdometer), style: AppText.heroOdometer),
              const SizedBox(width: 6),
              const Text('km',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    fontFamily: AppText.fontFamily,
                  )),
              const Spacer(),
              // 주행거리 수정 버튼
              GestureDetector(
                onTap: () => _showOdometerSheet(context, ref),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: AppColors.accentBg,
                    borderRadius: AppRadius.button,
                  ),
                  child: const Text('수정',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.accent,
                        fontFamily: AppText.fontFamily,
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOdometerSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OdometerSheet(
        current: vehicle.currentOdometer,
        onSave: (km) async {
          await ref
              .read(appDatabaseProvider)
              .updateVehicleOdometer(vehicle.id, km);
          ref.invalidate(vehiclesProvider);
          ref.invalidate(sortedItemStatusProvider(vehicle.id));
        },
      ),
    );
  }
}

// ─── 소모품 카드 ──────────────────────────────────────────────

class _ItemStatusCard extends ConsumerWidget {
  final int vehicleId;
  final bool groupByCategory;
  const _ItemStatusCard({
    required this.vehicleId,
    this.groupByCategory = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(sortedItemStatusProvider(vehicleId));

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.hairline),
        ),
        child: entriesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
                child: CircularProgressIndicator(color: AppColors.accent)),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text('오류: $e',
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          data: (entries) => groupByCategory
              ? _buildCategoryGroups(context, entries)
              : _buildFlatList(context, entries),
        ),
      ),
    );
  }

  Widget _buildFlatList(
      BuildContext context, List<ItemStatusEntry> entries) {
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          _ItemStatusRow(
            spec: entries[i].spec,
            result: entries[i].result,
            onTap: () => _pushDetail(context, entries[i].spec.id),
            onQuickAdd: () => _pushDetailWithForm(context, entries[i].spec.id),
          ),
          if (i < entries.length - 1)
            const Divider(
                height: 1,
                indent: AppSpacing.cardPaddingH,
                color: AppColors.hairline),
        ],
      ],
    );
  }

  Widget _buildCategoryGroups(
      BuildContext context, List<ItemStatusEntry> entries) {
    // 카테고리 기준으로 그룹핑 (상태 순서는 유지)
    final grouped = <String, List<ItemStatusEntry>>{};
    for (final e in entries) {
      grouped.putIfAbsent(e.spec.category, () => []).add(e);
    }
    final categories = grouped.keys.toList()..sort();

    final children = <Widget>[];
    for (var ci = 0; ci < categories.length; ci++) {
      final cat = categories[ci];
      final group = grouped[cat]!;

      // 카테고리 헤더
      children.add(Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.cardPaddingH,
          ci == 0 ? 14 : 10,
          AppSpacing.cardPaddingH,
          6,
        ),
        child: Row(
          children: [
            Text(
              cat,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
                fontFamily: AppText.fontFamily,
                letterSpacing: 0.02,
              ),
            ),
          ],
        ),
      ));

      for (final entry in group) {
        children.add(_ItemStatusRow(
          spec: entry.spec,
          result: entry.result,
          onTap: () => _pushDetail(context, entry.spec.id),
          onQuickAdd: () => _pushDetailWithForm(context, entry.spec.id),
        ));
      }
    }

    // 마지막 카테고리 아래 여백
    children.add(const SizedBox(height: 8));

    return Column(children: children);
  }

  void _pushDetail(BuildContext context, int specId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          ItemDetailScreen(specId: specId, vehicleId: vehicleId),
    ));
  }

  void _pushDetailWithForm(BuildContext context, int specId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ItemDetailScreen(
        specId: specId,
        vehicleId: vehicleId,
        autoOpenForm: true,
      ),
    ));
  }
}

// ─── 소모품 행 ────────────────────────────────────────────────

class _ItemStatusRow extends StatelessWidget {
  final ItemSpec spec;
  final RemainingLifeResult result;
  final VoidCallback? onTap;
  final VoidCallback? onQuickAdd;
  const _ItemStatusRow({
    required this.spec,
    required this.result,
    this.onTap,
    this.onQuickAdd,
  });

  @override
  Widget build(BuildContext context) {
    final (fillColor, fillGradient) = _gaugeStyle(result.status);
    final remainText = _remainText(result);
    final remainColor = _remainColor(result.status);
    final showBadge = result.status == ItemStatus.warn ||
        result.status == ItemStatus.overdue;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.card,
      child: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPaddingH, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 항목명 + 배지
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(spec.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            fontFamily: AppText.fontFamily,
                          )),
                    ),
                    if (showBadge) ...[
                      const SizedBox(width: 8),
                      _StatusBadge(result.status),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 잔여 텍스트
              Text(
                remainText,
                style: TextStyle(
                  fontSize: 13,
                  color: remainColor,
                  fontFamily: AppText.fontFamily,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 10),
              // 빠른 기록 추가 버튼
              GestureDetector(
                onTap: onQuickAdd,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accentBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded,
                      size: 18, color: AppColors.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 게이지 트랙
          ClipRRect(
            borderRadius: AppRadius.gauge,
            child: Container(
              height: 6,
              color: const Color(0x18FFFFFF),
              alignment: Alignment.centerLeft,
              child: result.status == ItemStatus.unknown
                  ? const SizedBox.shrink()
                  : _AnimatedGaugeFill(
                      ratio: result.ratio ?? 0,
                      fillColor: fillColor,
                      fillGradient: fillGradient,
                    ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  // (solid color, gradient) — 한 쪽만 사용
  (Color?, LinearGradient?) _gaugeStyle(ItemStatus status) => switch (status) {
        ItemStatus.ok => (
            null,
            const LinearGradient(
                colors: [AppColors.accent2, AppColors.accent])
          ),
        ItemStatus.warn => (AppColors.amber, null),
        ItemStatus.overdue => (AppColors.red, null),
        ItemStatus.unknown => (null, null),
      };

  Color _remainColor(ItemStatus status) => switch (status) {
        ItemStatus.ok => AppColors.textSecondary,
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
      return km >= 0
          ? '${fmtKm(km)} km 남음'
          : '${fmtKm(-km)} km 초과';
    }

    return '-';
  }
}

// ─── 상태 배지 ────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final ItemStatus status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      ItemStatus.warn => (AppColors.amberBg, AppColors.amber, '교체 권장'),
      ItemStatus.overdue => (AppColors.redBg, AppColors.red, '교체 필요'),
      _ => (AppColors.amberBg, AppColors.amber, '교체 권장'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.badge),
      child: Text(label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: fg,
            fontFamily: AppText.fontFamily,
          )),
    );
  }
}

// ─── 게이지 애니메이션 ─────────────────────────────────────────

class _AnimatedGaugeFill extends StatelessWidget {
  final double ratio;
  final Color? fillColor;
  final LinearGradient? fillGradient;
  const _AnimatedGaugeFill(
      {required this.ratio, this.fillColor, this.fillGradient});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(ratio),
      tween: Tween(begin: 0, end: ratio),
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
    );
  }
}
