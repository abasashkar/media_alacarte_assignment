import 'package:flutter/material.dart';

/// Brand and semantic colors derived from the Figma design (dark, teal accent).
class AppColors {
  const AppColors._();

  // Brand
  static const Color primary = Color(0xFF19C3C9); // teal / cyan accent
  static const Color primaryDark = Color(0xFF0E8C91);

  // Accent gradient (used on KPIs, progress bars, primary chips)
  static const Color accentA = Color(0xFF17D1D6);
  static const Color accentB = Color(0xFF3AE0B9);

  // Gradient backdrop + ambient glows
  static const Color gradientTop = Color(0xFF10141B);
  static const Color gradientBottom = Color(0xFF070809);
  static const Color glowTeal = Color(0xFF19C3C9);
  static const Color glowPurple = Color(0xFF7A5CFF);

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentA, accentB],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Channel colors (Spend Summary donut)
  static const Color channelSearch = Color(0xFF19C3C9);
  static const Color channelSocial = Color(0xFF2F80ED);
  static const Color channelDisplay = Color(0xFF9B51E0);

  // Semantic (anomaly severity & status)
  static const Color danger = Color(0xFFEB5757); // spend spike
  static const Color warning = Color(0xFFF2C94C); // ctr drop
  static const Color success = Color(0xFF27AE60); // active / positive
  static const Color neutral = Color(0xFF828282); // ended / muted

  // Dark surfaces — surface is intentionally lighter than the background so
  // cards read as clearly elevated without needing a visible border.
  static const Color darkBackground = Color(0xFF090A0D);
  static const Color darkSurface = Color(0xFF1B1E26);
  static const Color darkSurfaceVariant = Color(0xFF24272F);

  // Light surfaces
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEDF0F4);
}
