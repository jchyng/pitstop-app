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

class _HistoryBody extends ConsumerStatefulWidget {
  final int vehicleId;
  const _HistoryBody({required this.vehicleId});

  @override
  ConsumerState<_HistoryBody> createState() => _HistoryBodyState();
}

class _HistoryBodyState extends ConsumerState<_HistoryBody> {
  String? _typeFilter;  // null = 전체
  int? _specFilter;     // null = 전체
  String? _specFilterName;

  List<RecordWithSpec> _applyFilters(List<RecordWithSpec> all) {
    return all.where((e) {
      if (_typeFilter != null && e.record.type != _typeFilter) return false;
      if (_specFilter != null && e.record.itemSpecId != _specFilter) return false;
      return true;
    }).toList();
  }

  // 엔트리에서 고유 스펙 목록 추출
  Map<int, String> _extractSpecs(List<RecordWithSpec> entries) {
    final specs = <int, String>{};
    for (final e in entries) {
      if (e.spec != null) specs[e.spec!.id] = e.spec!.name;
    }
    return specs;
  }

  void _openSpecSheet(BuildContext context, Map<int, String> specs) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SpecSelectorSheet(
        specs: specs,
        selectedId: _specFilter,
        onSelect: (id, name) {
          setState(() {
            _specFilter = id;
            _specFilterName = name;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(allMaintenanceRecordsProvider(widget.vehicleId));

    return CustomScrollView(
      slivers: [
        // ── 헤더 ───────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH, 24, AppSpacing.screenPaddingH, 0),
            child: Text('정비이력', style: AppText.h1),
          ),
        ),

        // ── 필터 영역 ──────────────────────────────────────────
        SliverToBoxAdapter(
          child: recordsAsync.maybeWhen(
            data: (entries) {
              final specs = _extractSpecs(entries);
              return _FilterBar(
                typeFilter: _typeFilter,
                specFilter: _specFilter,
                specFilterName: _specFilterName,
                hasSpecs: specs.isNotEmpty,
                onTypeChanged: (t) => setState(() => _typeFilter = t),
                onSpecTap: specs.isEmpty
                    ? null
                    : () => _openSpecSheet(context, specs),
                onSpecClear: () => setState(() {
                  _specFilter = null;
                  _specFilterName = null;
                }),
              );
            },
            orElse: () => const SizedBox(height: 16),
          ),
        ),

        // ── 이력 목록 ─────────────────────────────────────────
        recordsAsync.when(
          loading: () => const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(
                  child: CircularProgressIndicator(color: AppColors.accent)),
            ),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Center(
              child: Text('오류: $e',
                  style: const TextStyle(color: AppColors.textSecondary)),
            ),
          ),
          data: (entries) {
            final filtered = _applyFilters(entries);
            if (entries.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: EmptyState(
                    icon: Icons.history_rounded,
                    title: '정비 기록이 없습니다',
                    description: '홈 화면에서 소모품을 탭해 첫 기록을 추가해보세요',
                  ),
                ),
              );
            }
            if (filtered.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: EmptyState(
                    icon: Icons.filter_list_off_rounded,
                    title: '해당 조건의 기록이 없습니다',
                    description: '필터를 변경해 다시 확인해보세요',
                  ),
                ),
              );
            }
            return _RecordSliver(
                entries: filtered, vehicleId: widget.vehicleId);
          },
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

// ─── 필터 바 ──────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final String? typeFilter;
  final int? specFilter;
  final String? specFilterName;
  final bool hasSpecs;
  final ValueChanged<String?> onTypeChanged;
  final VoidCallback? onSpecTap;
  final VoidCallback onSpecClear;

  const _FilterBar({
    required this.typeFilter,
    required this.specFilter,
    required this.specFilterName,
    required this.hasSpecs,
    required this.onTypeChanged,
    required this.onSpecTap,
    required this.onSpecClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPaddingH, 16, AppSpacing.screenPaddingH, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 작업 유형 칩 행
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _TypeChip(
                  label: '전체',
                  active: typeFilter == null,
                  onTap: () => onTypeChanged(null),
                ),
                const SizedBox(width: 8),
                _TypeChip(
                  label: '교체',
                  dotColor: AppColors.accent,
                  active: typeFilter == 'replace',
                  onTap: () => onTypeChanged(
                      typeFilter == 'replace' ? null : 'replace'),
                ),
                const SizedBox(width: 8),
                _TypeChip(
                  label: '점검',
                  dotColor: AppColors.teal,
                  active: typeFilter == 'inspect',
                  onTap: () => onTypeChanged(
                      typeFilter == 'inspect' ? null : 'inspect'),
                ),
                const SizedBox(width: 8),
                _TypeChip(
                  label: '보충',
                  dotColor: AppColors.amber,
                  active: typeFilter == 'refill',
                  onTap: () => onTypeChanged(
                      typeFilter == 'refill' ? null : 'refill'),
                ),
                // 소모품 필터
                if (hasSpecs) ...[
                  const SizedBox(width: 12),
                  Container(width: 1, height: 20, color: AppColors.hairline),
                  const SizedBox(width: 12),
                  if (specFilter != null)
                    _SpecActiveChip(
                      name: specFilterName ?? '',
                      onClear: onSpecClear,
                    )
                  else
                    _SpecPickerChip(onTap: onSpecTap),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final Color? dotColor;
  final bool active;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    this.dotColor,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.accentBg : AppColors.surface,
          borderRadius: AppRadius.chipShape,
          border: Border.all(
            color: active ? AppColors.accent : AppColors.hairline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? dotColor! : AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                color: active ? AppColors.accent : AppColors.textSecondary,
                fontFamily: AppText.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecPickerChip extends StatelessWidget {
  final VoidCallback? onTap;
  const _SpecPickerChip({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.chipShape,
          border: Border.all(color: AppColors.hairline),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune_rounded, size: 14, color: AppColors.textTertiary),
            SizedBox(width: 6),
            Text(
              '소모품',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontFamily: AppText.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecActiveChip extends StatelessWidget {
  final String name;
  final VoidCallback onClear;
  const _SpecActiveChip({required this.name, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentBg,
        borderRadius: AppRadius.chipShape,
        border: Border.all(color: AppColors.accent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.accent,
                fontFamily: AppText.fontFamily,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close_rounded,
                size: 14, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

// ─── 소모품 선택 바텀시트 ─────────────────────────────────────

class _SpecSelectorSheet extends StatelessWidget {
  final Map<int, String> specs;
  final int? selectedId;
  final void Function(int? id, String? name) onSelect;

  const _SpecSelectorSheet({
    required this.specs,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final entries = specs.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadius.bottomSheet,
      ),
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 그래버
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(40),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, 12),
            child: const Text('소모품 선택',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  fontFamily: AppText.fontFamily,
                )),
          ),
          // 전체 옵션
          _SpecRow(
            name: '전체',
            selected: selectedId == null,
            onTap: () => onSelect(null, null),
          ),
          const Divider(
              height: 1,
              indent: AppSpacing.screenPaddingH,
              color: AppColors.hairline),
          // 개별 스펙
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.45,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: entries.length,
              separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  indent: AppSpacing.screenPaddingH,
                  color: AppColors.hairline),
              itemBuilder: (_, i) => _SpecRow(
                name: entries[i].value,
                selected: selectedId == entries[i].key,
                onTap: () => onSelect(entries[i].key, entries[i].value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _SpecRow(
      {required this.name, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      selected ? FontWeight.w500 : FontWeight.w400,
                  color: selected
                      ? AppColors.accent
                      : AppColors.textPrimary,
                  fontFamily: AppText.fontFamily,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_rounded,
                  size: 18, color: AppColors.accent),
          ],
        ),
      ),
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
    final grouped = <String, List<RecordWithSpec>>{};
    for (final e in entries) {
      final key = '${e.record.date.year}년 ${e.record.date.month}월';
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
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPaddingH, 0,
                  AppSpacing.screenPaddingH, 10),
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
                      child: Container(height: 1, color: AppColors.hairline)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPaddingH, 0,
                  AppSpacing.screenPaddingH, 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.card,
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < recs.length; i++) ...[
                      _RecordRow(entry: recs[i], vehicleId: vehicleId),
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
                builder: (_) =>
                    ItemDetailScreen(specId: spec.id, vehicleId: vehicleId),
              ))
          : null,
      borderRadius: AppRadius.card,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPaddingH, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(top: 2, right: 12),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: dotColor),
            ),
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
        'replace' => (AppColors.accent, AppColors.accentBg, AppColors.accent, '교체'),
        'inspect' => (AppColors.teal, AppColors.tealBg, AppColors.teal, '점검'),
        'refill'  => (AppColors.amber, AppColors.amberBg, AppColors.amber, '보충'),
        _ => (AppColors.textTertiary, AppColors.chip, AppColors.textSecondary, type),
      };
}
