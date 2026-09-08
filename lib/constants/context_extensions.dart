import 'package:flutter/material.dart';
import 'app_colors.dart';

extension AppColorsX on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get colorBackground =>
      isDarkMode ? AppColors.backgroundDark : AppColors.background;

  Color get colorSurface =>
      isDarkMode ? AppColors.surfaceDark : AppColors.surface;

  Color get colorTextPrimary =>
      isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary;

  Color get colorTextSecondary =>
      isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondary;

  Color get colorBorder => isDarkMode ? AppColors.borderDark : AppColors.border;
}
