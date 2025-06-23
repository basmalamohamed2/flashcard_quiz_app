import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool enabled;
  final double borderRadius;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.enabled = true,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: labelText,
              border: InputBorder.none,
              labelStyle: const TextStyle(color: AppColors.textColor),
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            style: const TextStyle(color: AppColors.textColor),
          ),
        ),
      ),
    );
  }
}
