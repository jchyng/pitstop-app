import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// 빈 상태 공통 컴포넌트.
/// 아이콘, 제목, 설명 텍스트를 조합해 일관된 empty state를 표시한다.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: AppColors.textTertiary),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              fontFamily: AppText.fontFamily,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 5),
            Text(
              description!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textTertiary,
                fontFamily: AppText.fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
