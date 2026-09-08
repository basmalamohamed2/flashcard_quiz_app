import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/constants/context_extensions.dart';
import 'package:flutter/material.dart';

enum OptionState {
  normal,
  selectedCorrect,
  selectedWrong,
  correctReveal,
  disabled,
}

class OptionTile extends StatelessWidget {
  final String letter;
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.letter,
    required this.text,
    required this.state,
    this.onTap,
  });

  bool get _isColored =>
      state == OptionState.selectedCorrect ||
      state == OptionState.selectedWrong ||
      state == OptionState.correctReveal;

  Color _borderColor(BuildContext context) {
    switch (state) {
      case OptionState.selectedCorrect:
      case OptionState.correctReveal:
        return AppColors.success;
      case OptionState.selectedWrong:
        return AppColors.error;
      case OptionState.normal:
      case OptionState.disabled:
        return context.colorBorder;
    }
  }

  Color _backgroundColor(BuildContext context) {
    switch (state) {
      case OptionState.selectedCorrect:
      case OptionState.correctReveal:
        return AppColors.success.withOpacity(0.08);
      case OptionState.selectedWrong:
        return AppColors.error.withOpacity(0.08);
      case OptionState.normal:
      case OptionState.disabled:
        return context.colorSurface;
    }
  }

  Color get _badgeColor {
    switch (state) {
      case OptionState.selectedCorrect:
      case OptionState.correctReveal:
        return AppColors.success;
      case OptionState.selectedWrong:
        return AppColors.error;
      case OptionState.normal:
      case OptionState.disabled:
        return AppColors.primary.withOpacity(0.1);
    }
  }

  Widget? get _trailingIcon {
    switch (state) {
      case OptionState.selectedCorrect:
      case OptionState.correctReveal:
        return const Icon(
          Icons.check_circle_rounded,
          color: AppColors.success,
          size: 22,
        );
      case OptionState.selectedWrong:
        return const Icon(
          Icons.cancel_rounded,
          color: AppColors.error,
          size: 22,
        );
      case OptionState.normal:
      case OptionState.disabled:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trailing = _trailingIcon;

    return Opacity(
      opacity: state == OptionState.disabled ? 0.5 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: _backgroundColor(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _borderColor(context),
              width: _isColored ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      _isColored
                          ? _badgeColor
                          : AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: _isColored ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: AppTextStyles.body(context))),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}
