import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH, 24, AppSpacing.screenPaddingH, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '더보기',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  fontFamily: AppText.fontFamily,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: Text(
                  '설정 및 기타 기능',
                  style: TextStyle(color: AppColors.textTertiary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
