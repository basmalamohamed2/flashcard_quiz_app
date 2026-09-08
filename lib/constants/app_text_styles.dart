import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'context_extensions.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1(BuildContext context) => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: context.colorTextPrimary,
    height: 1.3,
  );

  static TextStyle heading2(BuildContext context) => GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: context.colorTextPrimary,
  );

  static TextStyle body(BuildContext context) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: context.colorTextPrimary,
    height: 1.4,
  );

  static TextStyle bodySecondary(BuildContext context) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: context.colorTextSecondary,
    height: 1.4,
  );

  static TextStyle caption(BuildContext context) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: context.colorTextSecondary,
    letterSpacing: 0.3,
  );
}
