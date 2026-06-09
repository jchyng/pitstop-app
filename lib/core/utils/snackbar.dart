import 'package:flutter/material.dart';
import '../theme/tokens.dart';

void showAppSnackBar(
  BuildContext context,
  String message, {
  Widget? leading,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: leading != null
        ? Row(children: [
            leading,
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: AppText.fontFamily,
                ),
              ),
            ),
          ])
        : Text(
            message,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: AppText.fontFamily,
            ),
          ),
    backgroundColor: AppColors.surface2,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
  ));
}
