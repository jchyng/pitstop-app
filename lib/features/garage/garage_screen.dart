import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/tokens.dart';
import '../../core/db/database.dart';
import '../../providers.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initAsync = ref.watch(appInitProvider);

    return initAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text('초기화 오류: $e',
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ),
      data: (_) => const _GarageBody(),
    );
  }
}

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
            // 상단 툴바
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 16, AppSpacing.screenPaddingH, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '내 차고',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.04,
                        fontFamily: AppText.fontFamily,
                      ),
                    ),
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

            // 차량 히어로 섹션
            SliverToBoxAdapter(
              child: vehiclesAsync.when(
                loading: () => const SizedBox(height: 120),
                error: (err, st) => const SizedBox(height: 120),
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
                error: (err, st) => const SizedBox(),
                data: (vehicles) => vehicles.isEmpty
                    ? const SizedBox()
                    : _ItemSpecsCard(vehicleId: vehicles.first.id),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

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
          Row(
            children: [
              Text(vehicle.name,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(width: 7),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 18, color: AppColors.textTertiary),
            ],
          ),
          if (vehicle.trim != null) ...[
            const SizedBox(height: 3),
            Text(vehicle.trim!,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
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
              Text(
                _formatOdometer(vehicle.currentOdometer),
                style: AppText.heroOdometer,
              ),
              const SizedBox(width: 7),
              const Text(
                'km',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  fontFamily: AppText.fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatOdometer(int km) {
    // 천단위 콤마 (intl 없이 간단 포맷)
    final s = km.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _EmptyVehicle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPaddingH, 32, AppSpacing.screenPaddingH, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('차량을 등록해주세요',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('카탈로그에서 내 차량을 선택하면\n소모품 현황이 자동으로 설정됩니다.',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ItemSpecsCard extends ConsumerWidget {
  final int vehicleId;
  const _ItemSpecsCard({required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specsAsync = ref.watch(itemSpecsProvider(vehicleId));

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.hairline),
        ),
        child: specsAsync.when(
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
          data: (specs) => Column(
            children: [
              for (var i = 0; i < specs.length; i++) ...[
                _ItemRow(spec: specs[i]),
                if (i < specs.length - 1)
                  const Divider(indent: 0, endIndent: 0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final ItemSpec spec;
  const _ItemRow({required this.spec});

  @override
  Widget build(BuildContext context) {
    // 이력 없는 초기 상태 — 게이지/잔여 계산 불가
    final hasOdometer = spec.lastReplacedOdometer != null;
    final intervalKm = spec.intervalKm;

    String remainText = '기록 없음';
    double ratio = 1.0;
    bool isWarn = false;

    if (hasOdometer && intervalKm != null) {
      // 핸드오프 3.1 계산 (거리 기준만, 날짜 기준은 추후)
      final remaining =
          spec.lastReplacedOdometer! + intervalKm - 0; // current_odometer=0 기준
      ratio = (remaining / intervalKm).clamp(0.0, 1.0);
      isWarn = ratio <= 0.15 || remaining <= 1000;
      remainText = '${_fmt(remaining)} km 남음';
    } else if (spec.intervalKm == null && spec.intervalMonths != null) {
      remainText = '주기: ${spec.intervalMonths}개월';
    } else if (spec.intervalKm != null) {
      remainText = '${_fmt(spec.intervalKm!)} km 주기';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPaddingH, vertical: 18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(spec.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontFamily: AppText.fontFamily,
                    )),
              ),
              Text(
                remainText,
                style: TextStyle(
                  fontSize: 14,
                  color: isWarn ? AppColors.amber : AppColors.textSecondary,
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
              color: const Color(0x0FFFFFFF), // track
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: ratio,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isWarn
                        ? null
                        : const LinearGradient(
                            colors: [AppColors.accent2, AppColors.accent],
                          ),
                    color: isWarn ? AppColors.amber : null,
                    borderRadius: AppRadius.gauge,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
