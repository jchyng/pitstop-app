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

class _GarageBody extends ConsumerWidget {
  final VoidCallback? onNavigateToMore;
  const _GarageBody({this.onNavigateToMore});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
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
                          fontSize: 11,
                          color: AppColors.textTertiary,
                          letterSpacing: 0.05,
                          fontFamily: AppText.fontFamily,
                          fontWeight: FontWeight.w500,
                        )),
                    GestureDetector(
                      onTap: onNavigateToMore,
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
              child: GestureDetector(
                onTap: onNavigateToMore,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPaddingH, 28, AppSpacing.screenPaddingH, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('소모품 현황',
                          style: Theme.of(context).textTheme.titleMedium),
                      const Icon(Icons.chevron_right_rounded,
                          size: 18, color: AppColors.textTertiary),
                    ],
                  ),
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
                    : _ItemStatusCard(vehicleId: vehicles.first.id),
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
          Row(children: [
            Flexible(
              child: Text(vehicle.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 18, color: AppColors.textTertiary),
          ]),
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
          const SizedBox(height: 6),
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
                      horizontal: 14, vertical: 8),
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
  const _ItemStatusCard({required this.vehicleId});

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
          data: (entries) => Column(
            children: [
              for (var i = 0; i < entries.length; i++) ...[
                _ItemStatusRow(
                  spec: entries[i].spec,
                  result: entries[i].result,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ItemDetailScreen(
                        specId: entries[i].spec.id,
                        vehicleId: vehicleId,
                      ),
                    ),
                  ),
                  onQuickAdd: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ItemDetailScreen(
                        specId: entries[i].spec.id,
                        vehicleId: vehicleId,
                        autoOpenForm: true,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
          horizontal: AppSpacing.cardPaddingH, vertical: 16),
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
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.accentBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded,
                      size: 16, color: AppColors.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 게이지 트랙
          ClipRRect(
            borderRadius: AppRadius.gauge,
            child: Container(
              height: 5,
              color: const Color(0x0FFFFFFF),
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
