import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Rounded surface container used throughout the app, optionally tappable.
///
/// Relies on a lighter surface colour plus a soft, diffuse shadow for
/// separation rather than a visible border, giving a calm, premium feel.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.onTap,
    this.color,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = color ?? theme.cardTheme.color ?? theme.colorScheme.surface;
    final radius = BorderRadius.circular(AppSpacing.radiusXl);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: isDark
            ? const [
                BoxShadow(
                  color: Color(0x4D000000),
                  blurRadius: 32,
                  spreadRadius: -8,
                  offset: Offset(0, 16),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x141B2A4A),
                  blurRadius: 28,
                  spreadRadius: -6,
                  offset: Offset(0, 12),
                ),
              ],
      ),
      child: Material(
        color: surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            // Only a whisper of a top highlight for definition; no hard border.
            decoration: border == null
                ? BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: isDark ? 0.035 : 0.03),
                    ),
                  )
                : BoxDecoration(borderRadius: radius, border: border),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
