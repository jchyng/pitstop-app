import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../utils/format.dart';
import '../utils/snackbar.dart';

class OdometerSheet extends StatefulWidget {
  final int current;
  final Future<void> Function(int km) onSave;

  const OdometerSheet({
    super.key,
    required this.current,
    required this.onSave,
  });

  @override
  State<OdometerSheet> createState() => _OdometerSheetState();
}

class _OdometerSheetState extends State<OdometerSheet> {
  late final TextEditingController _ctrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
        text: widget.current > 0 ? fmtKm(widget.current) : '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final km = int.tryParse(_ctrl.text.trim().replaceAll(',', ''));
    if (km == null || km <= 0) {
      showAppSnackBar(context, '올바른 주행거리를 입력해주세요');
      return;
    }
    if (km < widget.current) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface2,
          title: const Text('주행거리 줄어듦',
              style: TextStyle(color: AppColors.textPrimary)),
          content: Text(
            '현재값(${fmtKm(widget.current)} km)보다 낮습니다. 수정하시겠어요?',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('수정',
                  style: TextStyle(color: AppColors.amber)),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    setState(() => _saving = true);
    try {
      await widget.onSave(km);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showAppSnackBar(context, '저장 실패: $e');
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
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('주행거리 업데이트',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    fontFamily: AppText.fontFamily,
                  )),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.chip,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 20, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '현재: ${fmtKm(widget.current)} km',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textTertiary,
                fontFamily: AppText.fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 입력 필드
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              border: Border.all(color: AppColors.hairline),
              borderRadius: AppRadius.button,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [ThousandsInputFormatter()],
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontFeatures: [FontFeature.tabularFigures()],
                      fontFamily: AppText.fontFamily,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const Text(' km',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      fontFamily: AppText.fontFamily,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 저장 버튼
          SizedBox(
            width: double.infinity,
            child: _saving
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent))
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
