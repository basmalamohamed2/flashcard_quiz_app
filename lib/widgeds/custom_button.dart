// lib/widgets/custom_button.dart
import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // جعل onPressed اختياريًا
  final Color backgroundColor;
  final bool enabled;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed, // الآن يمكن أن يكون null
    this.backgroundColor = AppColors.primaryColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? backgroundColor : AppColors.disabledColor,
        minimumSize: const Size(120, 50),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: enabled ? onPressed : null,
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.backgroundColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}