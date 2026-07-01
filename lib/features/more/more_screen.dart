import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/format.dart';
import '../../core/utils/snackbar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/form_widgets.dart';
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
            child: _VehicleCard(vehicle: vehicle),
          ),
        ),

        // 소모품 관리
        _SectionHeader('소모품 관리'),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, 0),
            child: _SpecManageCard(vehicleId: vehicle.id),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accentBg,
              borderRadius: AppRadius.iconBox,
            ),
            child: const Icon(Icons.directions_car_rounded,
                size: 24, color: AppColors.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(vehicle.model,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  fontFamily: AppText.fontFamily,
                )),
          ),
        ],
      ),
    );
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

// ─── 소모품 관리 카드 ─────────────────────────────────────────

class _SpecManageCard extends ConsumerWidget {
  final int vehicleId;
  const _SpecManageCard({required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specsAsync = ref.watch(allItemSpecsProvider(vehicleId));

    return specsAsync.when(
      loading: () => const _PlaceholderCard(height: 80),
      error: (_, _) => const SizedBox.shrink(),
      data: (specs) {
        if (specs.isEmpty) return const SizedBox.shrink();

        void toggle(ItemSpec spec, bool hidden) async {
          await ref
              .read(appDatabaseProvider)
              .toggleSpecHidden(spec.id, hidden: hidden);
          ref.invalidate(allItemSpecsProvider(vehicleId));
          ref.invalidate(sortedItemStatusProvider(vehicleId));
        }

        void showEditSheet(ItemSpec spec) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(context).bottom),
              child: _EditSpecSheet(spec: spec, vehicleId: vehicleId),
            ),
          );
        }

        void showAddSheet() {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(context).bottom),
              child: _AddSpecSheet(vehicleId: vehicleId),
            ),
          );
        }

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.card,
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < specs.length; i++) ...[
                    _SpecToggleRow(
                      spec: specs[i],
                      onToggle: (h) => toggle(specs[i], h),
                      onEdit: () => showEditSheet(specs[i]),
                    ),
                    if (i < specs.length - 1)
                      const Divider(
                          height: 1, indent: 52, color: AppColors.hairline),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: showAddSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.card,
                  border: Border.all(color: AppColors.hairline),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded,
                        size: 16, color: AppColors.textTertiary),
                    SizedBox(width: 6),
                    Text(
                      '소모품 추가',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                        fontFamily: AppText.fontFamily,
                      ),
                    ),
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

Color _specDotColor(String category) => switch (category) {
      '엔진·오일' => AppColors.amber,
      '연료·증발가스' => AppColors.teal,
      '공조·외부' => AppColors.indigo,
      '제동·냉각·변속' => AppColors.red,
      '점화·벨트' => AppColors.violet,
      '타이어·배터리' => AppColors.green,
      _ => AppColors.textTertiary,
    };

class _SpecToggleRow extends StatelessWidget {
  final ItemSpec spec;
  final void Function(bool hidden) onToggle;
  final VoidCallback onEdit;
  const _SpecToggleRow({
    required this.spec,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final active = !spec.isHidden;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onEdit,
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.cardPaddingH, 14, 8, 14),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? _specDotColor(spec.category)
                          : AppColors.textTertiary.withAlpha(60),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 14,
                            color: active
                                ? AppColors.textPrimary
                                : AppColors.textTertiary,
                            fontFamily: AppText.fontFamily,
                          ),
                          child: Text(spec.name),
                        ),
                        Text(
                          spec.category,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                            fontFamily: AppText.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.cardPaddingH),
          child: GestureDetector(
            onTap: () => onToggle(!active),
            child: _CompactToggle(active: active),
          ),
        ),
      ],
    );
  }
}

class _CompactToggle extends StatelessWidget {
  final bool active;
  const _CompactToggle({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 38,
      height: 22,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: active ? AppColors.accent : AppColors.chip,
        borderRadius: BorderRadius.circular(11),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: active ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
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
                  borderRadius: AppRadius.iconBox,
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

// ─── 소모품 주기 편집 시트 ─────────────────────────────────────

class _EditSpecSheet extends ConsumerStatefulWidget {
  final ItemSpec spec;
  final int vehicleId;
  const _EditSpecSheet({required this.spec, required this.vehicleId});

  @override
  ConsumerState<_EditSpecSheet> createState() => _EditSpecSheetState();
}

class _EditSpecSheetState extends ConsumerState<_EditSpecSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _kmCtrl;
  late final TextEditingController _monthCtrl;
  bool _saving = false;

  bool get _isCustom => widget.spec.key.startsWith('custom_');

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.spec.name);
    _kmCtrl = TextEditingController(
      text: widget.spec.intervalKm != null
          ? fmtKm(widget.spec.intervalKm!)
          : '',
    );
    _monthCtrl = TextEditingController(
      text: widget.spec.intervalMonths?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _kmCtrl.dispose();
    _monthCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _isCustom ? _nameCtrl.text.trim() : null;
    if (_isCustom && (name == null || name.isEmpty)) {
      showAppSnackBar(context, '이름을 입력해주세요');
      return;
    }
    final kmRaw = _kmCtrl.text.replaceAll(',', '').trim();
    final monthRaw = _monthCtrl.text.trim();
    final km = kmRaw.isEmpty ? null : int.tryParse(kmRaw);
    final months = monthRaw.isEmpty ? null : int.tryParse(monthRaw);
    if (kmRaw.isNotEmpty && km == null) {
      showAppSnackBar(context, 'km 값을 올바르게 입력해주세요');
      return;
    }
    if (monthRaw.isNotEmpty && months == null) {
      showAppSnackBar(context, '개월 값을 올바르게 입력해주세요');
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(appDatabaseProvider).updateItemSpec(
            widget.spec.id,
            name: name,
            intervalKm: km,
            intervalMonths: months,
          );
      ref.invalidate(allItemSpecsProvider(widget.vehicleId));
      ref.invalidate(itemSpecsProvider(widget.vehicleId));
      ref.invalidate(sortedItemStatusProvider(widget.vehicleId));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showAppSnackBar(context, '저장 실패: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadius.bottomSheet,
      ),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPaddingH, 14, AppSpacing.screenPaddingH, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _specDotColor(widget.spec.category),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.spec.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        fontFamily: AppText.fontFamily,
                      ),
                    ),
                    Text(
                      widget.spec.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                        fontFamily: AppText.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
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
                      size: 16, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isCustom) ...[
            const FormLabel('이름'),
            const SizedBox(height: 8),
            FormInputDecor(
              child: TextField(
                controller: _nameCtrl,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  fontFamily: AppText.fontFamily,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '소모품 이름',
                  hintStyle: TextStyle(
                      color: AppColors.textTertiary,
                      fontFamily: AppText.fontFamily),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
          const FormLabel('km 주기'),
          const SizedBox(height: 8),
          FormInputDecor(
            child: TextField(
              controller: _kmCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [ThousandsInputFormatter()],
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontFamily: AppText.fontFamily,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '비워두면 km 알림 없음',
                hintStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontFamily: AppText.fontFamily),
                suffixText: 'km',
                suffixStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontFamily: AppText.fontFamily),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const FormLabel('개월 주기'),
          const SizedBox(height: 8),
          FormInputDecor(
            child: TextField(
              controller: _monthCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontFamily: AppText.fontFamily,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '비워두면 기간 알림 없음',
                hintStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontFamily: AppText.fontFamily),
                suffixText: '개월',
                suffixStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontFamily: AppText.fontFamily),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              disabledBackgroundColor: AppColors.accent.withAlpha(80),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.button),
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('저장',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: AppText.fontFamily,
                    )),
          ),
        ],
      ),
    );
  }
}

// ─── 소모품 직접 추가 시트 ─────────────────────────────────────

const _kSpecCategories = [
  '엔진·오일',
  '연료·증발가스',
  '공조·외부',
  '제동·냉각·변속',
  '점화·벨트',
  '타이어·배터리',
];

const _kBehaviorOptions = [
  ('replace_only', '교체'),
  ('inspect_only', '점검'),
  ('both', '교체 · 점검'),
];

class _AddSpecSheet extends ConsumerStatefulWidget {
  final int vehicleId;
  const _AddSpecSheet({required this.vehicleId});

  @override
  ConsumerState<_AddSpecSheet> createState() => _AddSpecSheetState();
}

class _AddSpecSheetState extends ConsumerState<_AddSpecSheet> {
  final _nameCtrl = TextEditingController();
  final _kmCtrl = TextEditingController();
  final _monthCtrl = TextEditingController();
  String _category = _kSpecCategories.first;
  String _behavior = 'replace_only';
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _kmCtrl.dispose();
    _monthCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      showAppSnackBar(context, '이름을 입력해주세요');
      return;
    }
    final kmRaw = _kmCtrl.text.replaceAll(',', '').trim();
    final monthRaw = _monthCtrl.text.trim();
    final km = kmRaw.isEmpty ? null : int.tryParse(kmRaw);
    final months = monthRaw.isEmpty ? null : int.tryParse(monthRaw);
    if (kmRaw.isNotEmpty && km == null) {
      showAppSnackBar(context, 'km 값을 올바르게 입력해주세요');
      return;
    }
    if (monthRaw.isNotEmpty && months == null) {
      showAppSnackBar(context, '개월 값을 올바르게 입력해주세요');
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(appDatabaseProvider).addCustomItemSpec(
            vehicleId: widget.vehicleId,
            name: name,
            category: _category,
            intervalKm: km,
            intervalMonths: months,
            behavior: _behavior,
          );
      ref.invalidate(allItemSpecsProvider(widget.vehicleId));
      ref.invalidate(itemSpecsProvider(widget.vehicleId));
      ref.invalidate(sortedItemStatusProvider(widget.vehicleId));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showAppSnackBar(context, '저장 실패: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadius.bottomSheet,
      ),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPaddingH, 14, AppSpacing.screenPaddingH, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          const Text(
            '소모품 추가',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              fontFamily: AppText.fontFamily,
            ),
          ),
          const SizedBox(height: 20),
          const FormLabel('이름'),
          const SizedBox(height: 8),
          FormInputDecor(
            child: TextField(
              controller: _nameCtrl,
              autofocus: true,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontFamily: AppText.fontFamily,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '예: 타이어 로테이션',
                hintStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontFamily: AppText.fontFamily),
              ),
            ),
          ),
          const FormLabel('카테고리'),
          const SizedBox(height: 8),
          _DropdownRow<String>(
            value: _category,
            items: _kSpecCategories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height: 4),
          const FormLabel('km 주기 (선택)'),
          const SizedBox(height: 8),
          FormInputDecor(
            child: TextField(
              controller: _kmCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [ThousandsInputFormatter()],
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontFamily: AppText.fontFamily,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '없음',
                hintStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontFamily: AppText.fontFamily),
                suffixText: 'km',
                suffixStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontFamily: AppText.fontFamily),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const FormLabel('개월 주기 (선택)'),
          const SizedBox(height: 8),
          FormInputDecor(
            child: TextField(
              controller: _monthCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontFamily: AppText.fontFamily,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '없음',
                hintStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontFamily: AppText.fontFamily),
                suffixText: '개월',
                suffixStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontFamily: AppText.fontFamily),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const FormLabel('작업 유형'),
          const SizedBox(height: 8),
          _DropdownRow<String>(
            value: _behavior,
            items: _kBehaviorOptions
                .map((b) => DropdownMenuItem(value: b.$1, child: Text(b.$2)))
                .toList(),
            onChanged: (v) => setState(() => _behavior = v!),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              disabledBackgroundColor: AppColors.accent.withAlpha(80),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.button),
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('추가',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: AppText.fontFamily,
                    )),
          ),
        ],
      ),
    );
  }
}

class _DropdownRow<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  const _DropdownRow(
      {required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        border: Border.all(color: AppColors.hairline),
        borderRadius: AppRadius.button,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: AppColors.surface2,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
            fontFamily: AppText.fontFamily,
          ),
          iconEnabledColor: AppColors.textTertiary,
          isDense: true,
        ),
      ),
    );
  }
}
