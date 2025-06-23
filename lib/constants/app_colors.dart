import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF4CAF50);
  static const secondaryColor = Color(0xFF2196F3);
  static const backgroundGradientStart = Color(0xFFE8F5E9);
  static const backgroundGradientEnd = Color(0xFFE3F2FD);
  static const textColor = Color(0xFF2F4F4F);
  static const accentColor = Color(0xFFFF5722);
  static const backgroundColor = Color(0xFFFFFFFF);
  static const disabledColor = Color(0xFFB0BEC5);

  static const LinearGradient appBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundGradientStart, backgroundGradientEnd],
  );
}
