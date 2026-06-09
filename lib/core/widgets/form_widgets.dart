import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class FormLabel extends StatelessWidget {
  final String text;
  const FormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
          fontFamily: AppText.fontFamily,
        ),
      ),
    );
  }
}

class FormInputDecor extends StatelessWidget {
  final Widget child;
  const FormInputDecor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        border: Border.all(color: AppColors.hairline),
        borderRadius: AppRadius.button,
      ),
      child: child,
    );
  }
}
