import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/tokens.dart';
import '../../core/db/database.dart';
import '../../domain/logic/remaining_life.dart';
import '../../providers.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({super.key});

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
      data: (_) => const _GarageBody(),
    );
  }
}

// ─── 본문 ────────────────────────────────────────────────────

class _GarageBody extends ConsumerWidget {
  const _GarageBody();

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
                    AppSpacing.screenPaddingH, 16, AppSpacing.screenPaddingH, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('내 차고',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                          letterSpacing: 0.04,
                          fontFamily: AppText.fontFamily,
                        )),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: AppColors.chip,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.settings_outlined,
                          size: 19, color: AppColors.textSecondary),
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
                    ? _EmptyVehicle()
                    : _VehicleHero(vehicle: vehicles.first),
              ),
            ),

            // 소모품 현황 헤더
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 34, AppSpacing.screenPaddingH, 6),
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
                    AppSpacing.screenPaddingH, 16, AppSpacing.screenPaddingH, 24),
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

class _VehicleHero extends StatelessWidget {
  final Vehicle vehicle;
  const _VehicleHero({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPaddingH, 24, AppSpacing.screenPaddingH, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(vehicle.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(width: 7),
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
                fontSize: 12,
                color: AppColors.textTertiary,
                letterSpacing: 0.04,
                fontFamily: AppText.fontFamily,
              )),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(_fmtKm(vehicle.currentOdometer), style: AppText.heroOdometer),
              const SizedBox(width: 7),
              const Text('km',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    fontFamily: AppText.fontFamily,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyVehicle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPaddingH, 32, AppSpacing.screenPaddingH, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('차량을 등록해주세요',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('카탈로그에서 내 차량을 선택하면\n소모품 현황이 자동으로 설정됩니다.',
            style: Theme.of(context).textTheme.bodyMedium),
      ]),
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
                    spec: entries[i].spec, result: entries[i].result),
                if (i < entries.length - 1)
                  const Divider(height: 1, color: AppColors.hairline),
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
  const _ItemStatusRow({required this.spec, required this.result});

  @override
  Widget build(BuildContext context) {
    final (fillColor, fillGradient) = _gaugeStyle(result.status);
    final remainText = _remainText(result);
    final remainColor = _remainColor(result.status);
    final showBadge = result.status == ItemStatus.warn ||
        result.status == ItemStatus.overdue;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPaddingH, vertical: 18),
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
              const SizedBox(width: 12),
              // 잔여 텍스트
              Text(
                remainText,
                style: TextStyle(
                  fontSize: 14,
                  color: remainColor,
                  fontFamily: AppText.fontFamily,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
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
          ? '${_fmtKm(km)} km 남음'
          : '${_fmtKm(-km)} km 초과';
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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

// ─── 유틸 ─────────────────────────────────────────────────────

String _fmtKm(int km) => NumberFormat('#,##0').format(km);
