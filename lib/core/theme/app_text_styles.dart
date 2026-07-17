import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Builds a Material 3 [TextTheme] using the Inter font family.
class AppTextStyles {
  const AppTextStyles._();

  static TextTheme textTheme(TextTheme base) {
    return GoogleFonts.interTextTheme(base).copyWith(
      titleLarge: GoogleFonts.inter(
        textStyle: base.titleLarge,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.inter(
        textStyle: base.titleMedium,
        fontWeight: FontWeight.w600,
      ),
      labelLarge: GoogleFonts.inter(
        textStyle: base.labelLarge,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
