import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/odometer_sheet.dart';
import '../../domain/logic/remaining_life.dart';
import '../../providers.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: vehiclesAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
          error: (e, _) => Center(
            child: Text('오류: $e',
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          data: (vehicles) => vehicles.isEmpty
              ? const _NoVehicle()
              : _MoreBody(vehicle: vehicles.first),
        ),
      ),
    );
  }
}

// ─── 본문 ─────────────────────────────────────────────────────

class _MoreBody extends ConsumerWidget {
  final Vehicle vehicle;
  const _MoreBody({required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(sortedItemStatusProvider(vehicle.id));

    return CustomScrollView(
      slivers: [
        // 헤더
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH, 24, AppSpacing.screenPaddingH, 0),
            child: Text('더보기', style: AppText.h1),
          ),
        ),

        // 차량 정보 카드
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH, 24, AppSpacing.screenPaddingH, 0),
            child: _VehicleCard(vehicle: vehicle),
          ),
        ),

        // 주행거리 섹션
        _SectionHeader('주행거리 관리'),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, 0),
            child: _OdometerCard(
              vehicle: vehicle,
              onUpdate: (km) async {
                await ref
                    .read(appDatabaseProvider)
                    .updateVehicleOdometer(vehicle.id, km);
                ref.invalidate(vehiclesProvider);
                ref.invalidate(sortedItemStatusProvider(vehicle.id));
              },
            ),
          ),
        ),

        // 소모품 현황 요약
        _SectionHeader('소모품 현황'),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, 0),
            child: statusAsync.when(
              loading: () => const _PlaceholderCard(height: 80),
              error: (_, _) => const SizedBox.shrink(),
              data: (entries) => _StatusSummaryCard(entries: entries),
            ),
          ),
        ),

        // 앱 정보
        _SectionHeader('앱 정보'),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, 0),
            child: _AppInfoCard(vehicle: vehicle),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }
}

// ─── 섹션 헤더 ────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPaddingH, 30, AppSpacing.screenPaddingH, 10),
        child: Row(
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                  letterSpacing: 0.02,
                  fontFamily: AppText.fontFamily,
                )),
            const SizedBox(width: 10),
            Expanded(child: Container(height: 1, color: AppColors.hairline)),
          ],
        ),
      ),
    );
  }
}

// ─── 차량 정보 카드 ────────────────────────────────────────────

class _VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.hairline),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPaddingV),
      child: Row(
        children: [
          // 차량 아이콘
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.accentBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.directions_car_rounded,
                size: 26, color: AppColors.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontFamily: AppText.fontFamily,
                    )),
                const SizedBox(height: 3),
                Text(vehicle.model,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontFamily: AppText.fontFamily,
                    )),
                if (vehicle.trim != null || vehicle.year != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (vehicle.year != null) '${vehicle.year}년식',
                      if (vehicle.trim != null) vehicle.trim!,
                    ].join('  '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                      fontFamily: AppText.fontFamily,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 주행거리 카드 ────────────────────────────────────────────

class _OdometerCard extends StatelessWidget {
  final Vehicle vehicle;
  final Future<void> Function(int km) onUpdate;

  const _OdometerCard({required this.vehicle, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.hairline),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPaddingH, vertical: 18),
      child: Row(
        children: [
          const Icon(Icons.speed_rounded,
              size: 22, color: AppColors.textTertiary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('현재 주행거리',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                      fontFamily: AppText.fontFamily,
                    )),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: fmtKm(vehicle.currentOdometer),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.44,
                          fontFeatures: [FontFeature.tabularFigures()],
                          fontFamily: AppText.fontFamily,
                        ),
                      ),
                      const TextSpan(
                        text: ' km',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontFamily: AppText.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showUpdateSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accentBg,
                borderRadius: BorderRadius.circular(10),
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
    );
  }

  void _showUpdateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OdometerSheet(
        current: vehicle.currentOdometer,
        onSave: onUpdate,
      ),
    );
  }
}

// ─── 소모품 현황 요약 카드 ─────────────────────────────────────

class _StatusSummaryCard extends StatelessWidget {
  final List<ItemStatusEntry> entries;
  const _StatusSummaryCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    final ok = entries.where((e) => e.result.status == ItemStatus.ok).length;
    final warn =
        entries.where((e) => e.result.status == ItemStatus.warn).length;
    final overdue =
        entries.where((e) => e.result.status == ItemStatus.overdue).length;
    final unknown =
        entries.where((e) => e.result.status == ItemStatus.unknown).length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.hairline),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPaddingH, vertical: 18),
      child: Row(
        children: [
          Expanded(
              child: _StatusStat(label: '정상', count: ok, color: AppColors.accent)),
          _VDivider(),
          Expanded(
              child: _StatusStat(
                  label: '교체 권장', count: warn, color: AppColors.amber)),
          _VDivider(),
          Expanded(
              child: _StatusStat(
                  label: '초과', count: overdue, color: AppColors.red)),
          _VDivider(),
          Expanded(
              child: _StatusStat(
                  label: '이력 없음', count: unknown, color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}

class _StatusStat extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatusStat(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: count > 0 ? color : AppColors.textTertiary,
              fontFamily: AppText.fontFamily,
              fontFeatures: const [FontFeature.tabularFigures()],
            )),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
              fontFamily: AppText.fontFamily,
            )),
      ],
    );
  }
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.hairline);
  }
}

// ─── 앱 정보 카드 ─────────────────────────────────────────────

class _AppInfoCard extends StatelessWidget {
  final Vehicle vehicle;
  const _AppInfoCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.directions_car_outlined,
            label: '카탈로그',
            value: vehicle.model,
          ),
          const Divider(height: 1, indent: 52, color: AppColors.hairline),
          _InfoRow(
            icon: Icons.info_outline_rounded,
            label: '버전',
            value: 'v0.1.0',
          ),
          const Divider(height: 1, indent: 52, color: AppColors.hairline),
          _InfoRow(
            icon: Icons.storage_outlined,
            label: '데이터',
            value: '로컬 전용',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPaddingH, vertical: 15),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontFamily: AppText.fontFamily,
                )),
          ),
          Text(value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontFamily: AppText.fontFamily,
              )),
        ],
      ),
    );
  }
}

// ─── 빈 상태 ──────────────────────────────────────────────────

class _NoVehicle extends StatelessWidget {
  const _NoVehicle();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('차량을 먼저 등록해주세요',
          style: TextStyle(color: AppColors.textSecondary)),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final double height;
  const _PlaceholderCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.hairline),
      ),
    );
  }
}

