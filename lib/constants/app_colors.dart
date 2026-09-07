import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5B5FEF);
  static const Color primaryDark = Color(0xFF4347C4);
  static const Color secondary = Color(0xFF15C39A);
  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2333);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color disabled = Color(0xFFC7CBD9);
  static const Color border = Color(0xFFE5E7EB);

  static const List<Color> heroGradient = [
    Color(0xFF6C63FF),
    Color(0xFF4347C4),
  ];

  static const LinearGradient heroLinearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: heroGradient,
  );
}
