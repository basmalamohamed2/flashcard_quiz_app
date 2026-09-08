import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/constants/context_extensions.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? icon;
  final bool enabled;
  final int maxLines;
  final bool hasError;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.icon,
    this.enabled = true,
    this.maxLines = 1,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError ? AppColors.error : context.colorBorder;
    final focusColor = hasError ? AppColors.error : AppColors.primary;

    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      style: AppTextStyles.body(context),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon:
            icon != null
                ? Icon(icon, color: context.colorTextSecondary, size: 20)
                : null,
        filled: true,
        fillColor: context.colorSurface,
        labelStyle: AppTextStyles.bodySecondary(context),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: focusColor, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: context.colorBorder),
        ),
      ),
    );
  }
}
