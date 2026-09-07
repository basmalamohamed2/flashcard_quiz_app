import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, outline, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool enabled;
  final bool expand;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.enabled = true,
    this.expand = false,
  });

  bool get _isOutline => variant == ButtonVariant.outline;

  Color get _backgroundColor {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.secondary:
        return AppColors.secondary;
      case ButtonVariant.danger:
        return AppColors.error;
      case ButtonVariant.outline:
        return Colors.transparent;
    }
  }

  Color get _foregroundColor {
    return _isOutline ? AppColors.primary : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? _backgroundColor : AppColors.disabled,
        foregroundColor: _foregroundColor,
        disabledBackgroundColor: AppColors.disabled,
        elevation: _isOutline ? 0 : 2,
        shadowColor: AppColors.primary.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side:
              _isOutline
                  ? const BorderSide(color: AppColors.primary, width: 1.5)
                  : BorderSide.none,
        ),
        minimumSize:
            expand ? const Size(double.infinity, 54) : const Size(120, 54),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
