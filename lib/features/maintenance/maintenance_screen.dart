import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

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
                '정비이력',
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
                  '3단계에서 구현됩니다',
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
