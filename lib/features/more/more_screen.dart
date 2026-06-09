import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/empty_state.dart';
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
              ? const EmptyState(
                  icon: Icons.directions_car_outlined,
                  title: '차량을 먼저 등록해주세요',
                )
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
                AppSpacing.screenPaddingH, 20, AppSpacing.screenPaddingH, 0),
            child: _VehicleCard(
              vehicle: vehicle,
              onEditName: () => _showEditNameSheet(context, ref, vehicle),
            ),
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

        // 주유비 자동 감지
        _SectionHeader('주유비 자동 감지'),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, 0),
            child: const _FuelAutoCard(),
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

  void _showEditNameSheet(
      BuildContext context, WidgetRef ref, Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditNameSheet(
        current: vehicle.name,
        onSave: (newName) async {
          await ref
              .read(appDatabaseProvider)
              .updateVehicleName(vehicle.id, newName);
          ref.invalidate(vehiclesProvider);
        },
      ),
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
            AppSpacing.screenPaddingH, 28, AppSpacing.screenPaddingH, 10),
        child: Row(
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                  letterSpacing: 0.04,
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
  final VoidCallback? onEditName;
  const _VehicleCard({required this.vehicle, this.onEditName});

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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accentBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_car_rounded,
                size: 24, color: AppColors.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontFamily: AppText.fontFamily,
                    )),
                const SizedBox(height: 2),
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
          // 별칭 편집 버튼
          GestureDetector(
            onTap: onEditName,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.chip,
                borderRadius: AppRadius.button,
              ),
              child: const Text('편집',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    fontFamily: AppText.fontFamily,
                  )),
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
              size: 20, color: AppColors.textTertiary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('현재 주행거리',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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
                          fontSize: 13,
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
          horizontal: AppSpacing.cardPaddingH, vertical: 20),
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
              fontSize: 22,
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
    return Container(width: 1, height: 32, color: AppColors.hairline);
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
          const SizedBox(width: 12),
          Flexible(
            child: Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontFamily: AppText.fontFamily,
                )),
          ),
        ],
      ),
    );
  }
}

// ─── 주유비 자동 감지 카드 ─────────────────────────────────────

class _FuelAutoCard extends ConsumerStatefulWidget {
  const _FuelAutoCard();

  @override
  ConsumerState<_FuelAutoCard> createState() => _FuelAutoCardState();
}

class _FuelAutoCardState extends ConsumerState<_FuelAutoCard> {
  bool? _granted;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted = await NotificationService.isPermissionGranted();
    if (mounted) setState(() => _granted = granted);
  }

  @override
  Widget build(BuildContext context) {
    final granted = _granted;

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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accentBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bolt_rounded,
                    size: 20, color: AppColors.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('주유비 자동 감지',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                              fontFamily: AppText.fontFamily,
                            )),
                        if (granted == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.tealBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('활성화',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.teal,
                                  fontFamily: AppText.fontFamily,
                                )),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      granted == true
                          ? '카드 결제 알림에서 주유비를 감지합니다'
                          : '앱 실행 중 카드 결제 알림을 자동 기록합니다',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                        fontFamily: AppText.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (granted == false) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.hairline),
            const SizedBox(height: 14),
            const Text(
              '알림 접근 권한이 필요합니다. 설정에서 Pitstop을 활성화해주세요.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontFamily: AppText.fontFamily,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                await NotificationService.openPermissionSettings();
                // 설정에서 돌아올 때 권한 재확인
                await Future.delayed(const Duration(milliseconds: 500));
                _checkPermission();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.accentBg,
                  borderRadius: AppRadius.button,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('알림 권한 설정',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accent,
                          fontFamily: AppText.fontFamily,
                        )),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 12, color: AppColors.accent),
                  ],
                ),
              ),
            ),
          ] else if (granted == true) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.hairline),
            const SizedBox(height: 14),
            const Text(
              '앱이 실행 중일 때 GS칼텍스·SK에너지·S-OIL 등 주유소 결제 알림을 감지해 자동으로 가계부에 추가합니다.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
                fontFamily: AppText.fontFamily,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
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

// ─── 차량 별칭 편집 바텀시트 ──────────────────────────────────

class _EditNameSheet extends StatefulWidget {
  final String current;
  final Future<void> Function(String name) onSave;
  const _EditNameSheet({required this.current, required this.onSave});

  @override
  State<_EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends State<_EditNameSheet> {
  late final TextEditingController _ctrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.current);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _ctrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('별칭을 입력해주세요')));
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.onSave(name);
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
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadius.bottomSheet,
      ),
      padding: EdgeInsets.fromLTRB(22, 14, 22, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('차량 별칭 편집',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    fontFamily: AppText.fontFamily,
                  )),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.chip,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 18, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 입력 필드
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              border: Border.all(color: AppColors.hairline),
              borderRadius: AppRadius.button,
            ),
            child: TextField(
              controller: _ctrl,
              autofocus: true,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontFamily: AppText.fontFamily,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '예: 내 렉스턴',
                hintStyle:
                    TextStyle(color: AppColors.textTertiary, fontSize: 15),
                contentPadding: EdgeInsets.zero,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
            ),
          ),
          const SizedBox(height: 16),
          // 저장 버튼
          SizedBox(
            width: double.infinity,
            child: _saving
                ? const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.accent))
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
        ],
      ),
    );
  }
}
