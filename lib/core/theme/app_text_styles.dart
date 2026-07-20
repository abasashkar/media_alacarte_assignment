import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Builds a Material 3 [TextTheme] using the Inter font family.
class AppTextStyles {
  const AppTextStyles._();

  static TextTheme textTheme(TextTheme base) {
    final inter = GoogleFonts.interTextTheme(base);
    return inter.copyWith(
      // Large numbers / hero values.
      headlineSmall: GoogleFonts.inter(
        textStyle: base.headlineSmall,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.inter(
        textStyle: base.titleLarge,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      // Card titles — bumped to bold for a stronger hierarchy.
      titleMedium: GoogleFonts.inter(
        textStyle: base.titleMedium,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: -0.2,
      ),
      bodyMedium: GoogleFonts.inter(
        textStyle: base.bodyMedium,
        fontSize: 14,
        height: 1.35,
      ),
      // Secondary labels — lower emphasis with a touch more letter spacing.
      bodySmall: GoogleFonts.inter(
        textStyle: base.bodySmall,
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      labelLarge: GoogleFonts.inter(
        textStyle: base.labelLarge,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Emphasised style for standout metric values, consistent across screens.
  static TextStyle metricValue(TextTheme theme) {
    return (theme.titleMedium ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3,
    );
  }
}
