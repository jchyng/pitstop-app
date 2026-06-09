import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/empty_state.dart';
import '../../providers.dart';
import 'item_detail_screen.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

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
              ? const EmptyState(
                  icon: Icons.directions_car_outlined,
                  title: '차량을 먼저 등록해주세요',
                )
              : _HistoryBody(vehicleId: vehicles.first.id),
        ),
      ),
    );
  }
}

// ─── 본문 ─────────────────────────────────────────────────────

class _HistoryBody extends ConsumerWidget {
  final int vehicleId;
  const _HistoryBody({required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(allMaintenanceRecordsProvider(vehicleId));

    return CustomScrollView(
      slivers: [
        // 헤더
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH, 24, AppSpacing.screenPaddingH, 0),
            child: Text('정비이력', style: AppText.h1),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        recordsAsync.when(
          loading: () => const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 80),
              child:
                  Center(child: CircularProgressIndicator(color: AppColors.accent)),
            ),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Center(
              child: Text('오류: $e',
                  style: const TextStyle(color: AppColors.textSecondary)),
            ),
          ),
          data: (entries) => entries.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: EmptyState(
                      icon: Icons.history_rounded,
                      title: '정비 기록이 없습니다',
                      description: '홈 화면에서 소모품을 탭해 첫 기록을 추가해보세요',
                    ),
                  ),
                )
              : _RecordSliver(entries: entries, vehicleId: vehicleId),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

// ─── 월별 그룹 슬리버 ────────────────────────────────────────

class _RecordSliver extends StatelessWidget {
  final List<RecordWithSpec> entries;
  final int vehicleId;

  const _RecordSliver({required this.entries, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    // 월별 그룹핑
    final grouped = <String, List<RecordWithSpec>>{};
    for (final e in entries) {
      final key =
          '${e.record.date.year}년 ${e.record.date.month}월';
      grouped.putIfAbsent(key, () => []).add(e);
    }

    final months = grouped.keys.toList();

    return SliverList.builder(
      itemCount: months.length,
      itemBuilder: (ctx, mi) {
        final month = months[mi];
        final recs = grouped[month]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 월 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, 10),
              child: Row(
                children: [
                  Text(month,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                        fontFamily: AppText.fontFamily,
                        letterSpacing: 0.02,
                      )),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(height: 1, color: AppColors.hairline),
                  ),
                ],
              ),
            ),
            // 카드 목록
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.card,
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < recs.length; i++) ...[
                      _RecordRow(
                        entry: recs[i],
                        vehicleId: vehicleId,
                      ),
                      if (i < recs.length - 1)
                        const Divider(
                            height: 1,
                            indent: AppSpacing.cardPaddingH,
                            endIndent: AppSpacing.cardPaddingH,
                            color: AppColors.hairline),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── 이력 행 ──────────────────────────────────────────────────

class _RecordRow extends StatelessWidget {
  final RecordWithSpec entry;
  final int vehicleId;

  const _RecordRow({required this.entry, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    final rec = entry.record;
    final spec = entry.spec;
    final (dotColor, typeBg, typeFg, typeLabel) = _typeStyle(rec.type);

    return InkWell(
      onTap: spec != null
          ? () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ItemDetailScreen(
                    specId: spec.id, vehicleId: vehicleId),
              ))
          : null,
      borderRadius: AppRadius.card,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPaddingH, vertical: 14),
        child: Row(
          children: [
            // 타입 색점
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(top: 2, right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
            // 내용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          spec?.name ?? '기타 정비',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            fontFamily: AppText.fontFamily,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 타입 배지
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: typeBg,
                          borderRadius: AppRadius.badge,
                        ),
                        child: Text(typeLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: typeFg,
                              fontFamily: AppText.fontFamily,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${fmtKm(rec.odometer)} km',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontFamily: AppText.fontFamily,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      if (rec.place != null && rec.place!.isNotEmpty) ...[
                        const Text(' · ',
                            style: TextStyle(
                                color: AppColors.textTertiary, fontSize: 13)),
                        Flexible(
                          child: Text(
                            rec.place!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textTertiary,
                              fontFamily: AppText.fontFamily,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // 날짜
            const SizedBox(width: 12),
            Text(
              fmtDateShort(rec.date),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
                fontFamily: AppText.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color, Color, String) _typeStyle(String type) => switch (type) {
        'replace' => (
            AppColors.accent,
            AppColors.accentBg,
            AppColors.accent,
            '교체'
          ),
        'inspect' => (
            AppColors.teal,
            AppColors.tealBg,
            AppColors.teal,
            '점검'
          ),
        'refill' => (
            AppColors.amber,
            AppColors.amberBg,
            AppColors.amber,
            '보충'
          ),
        _ => (
            AppColors.textTertiary,
            AppColors.chip,
            AppColors.textSecondary,
            type
          ),
      };
}

// ─── 유틸 ─────────────────────────────────────────────────────
