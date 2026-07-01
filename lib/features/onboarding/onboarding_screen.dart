import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/catalog_loader.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/format.dart';
import '../../core/utils/snackbar.dart';
import '../../providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  List<CatalogInfo>? _catalogs;
  String? _selectedPath;
  final _odometerCtrl = TextEditingController();
  bool _catalogLoading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadCatalogs();
  }

  @override
  void dispose() {
    _odometerCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCatalogs() async {
    final cats = await CatalogLoader.listCatalogs();
    if (!mounted) return;
    setState(() {
      _catalogs = cats;
      _catalogLoading = false;
      if (cats.length == 1) _selectedPath = cats.first.assetPath;
    });
  }

  Future<void> _submit() async {
    if (_selectedPath == null) {
      _snack('차량을 선택해주세요');
      return;
    }
    final odomText = _odometerCtrl.text.trim().replaceAll(',', '');
    final odometer = int.tryParse(odomText);
    if (odometer == null || odometer < 0) {
      _snack('주행거리를 올바르게 입력해주세요');
      return;
    }

    setState(() => _saving = true);
    try {
      final db = ref.read(appDatabaseProvider);
      await CatalogLoader.seedFromCatalog(
        db,
        assetPath: _selectedPath!,
        odometer: odometer,
      );
      ref.invalidate(vehiclesProvider);
      // _RootRouter가 vehiclesProvider 변화를 감지해 자동으로 MainShell로 전환
    } catch (e) {
      if (mounted) _snack('등록 실패: $e');
      setState(() => _saving = false);
    }
  }

  void _snack(String msg) => showAppSnackBar(context, msg);

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH, 48,
              AppSpacing.screenPaddingH, 32 + bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 앱 타이틀 ───────────────────────────────────────
              const Text(
                'Pitstop',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accent,
                  fontFamily: AppText.fontFamily,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '내 차량을 등록해 소모품과\n유지비를 한눈에 관리하세요.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontFamily: AppText.fontFamily,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),

              // ── 차량 카탈로그 ────────────────────────────────────
              _SectionLabel('차량 카탈로그'),
              const SizedBox(height: 10),
              if (_catalogLoading)
                Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.card,
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                )
              else if (_catalogs == null || _catalogs!.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.card,
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: const Text('지원 차종이 없습니다.',
                      style: TextStyle(
                          color: AppColors.textTertiary,
                          fontFamily: AppText.fontFamily)),
                )
              else if (_catalogs!.length == 1)
                // 카탈로그가 1개면 자동 선택 — 이름 뱃지만 표시
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.accentBg,
                    borderRadius: AppRadius.card,
                    border: Border.all(color: AppColors.accent),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent,
                        ),
                        child: const Icon(Icons.check_rounded,
                            size: 14, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _catalogs!.first.nameKo,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.accent,
                            fontFamily: AppText.fontFamily,
                          ),
                        ),
                      ),
                      const Text(
                        '자동 선택',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.accent,
                          fontFamily: AppText.fontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                // 복수 카탈로그 — 스크롤 가능 영역
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 260),
                  child: ListView(
                    shrinkWrap: true,
                    children: _catalogs!.map((cat) {
                      final selected = _selectedPath == cat.assetPath;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedPath = cat.assetPath),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 16),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.accentBg
                                : AppColors.surface,
                            borderRadius: AppRadius.card,
                            border: Border.all(
                              color: selected
                                  ? AppColors.accent
                                  : AppColors.hairline,
                            ),
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selected
                                      ? AppColors.accent
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.accent
                                        : AppColors.textTertiary,
                                    width: 1.5,
                                  ),
                                ),
                                child: selected
                                    ? const Icon(Icons.check_rounded,
                                        size: 14, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  cat.nameKo,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: selected
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                    color: selected
                                        ? AppColors.accent
                                        : AppColors.textPrimary,
                                    fontFamily: AppText.fontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 32),

              // ── 현재 주행거리 ─────────────────────────────────────
              _SectionLabel('현재 주행거리'),
              const SizedBox(height: 10),
              _InputBox(
                controller: _odometerCtrl,
                hint: '예: 44,500',
                keyboardType: TextInputType.number,
                inputFormatters: [ThousandsInputFormatter()],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 6),
              const Text(
                '정확한 주행거리를 입력할수록 소모품 게이지가 정밀해집니다.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                  fontFamily: AppText.fontFamily,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 36),

              // ── 시작 버튼 ────────────────────────────────────────
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
                          onPressed: _submit,
                          style: TextButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 17),
                            shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.button),
                          ),
                          child: const Text(
                            '시작하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: AppText.fontFamily,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 공용 소위젯 ──────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
            letterSpacing: 0.04,
            fontFamily: AppText.fontFamily,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: AppColors.hairline)),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        fontFamily: AppText.fontFamily,
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _InputBox({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        border: Border.all(color: AppColors.hairline),
        borderRadius: AppRadius.button,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
          fontFamily: AppText.fontFamily,
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
