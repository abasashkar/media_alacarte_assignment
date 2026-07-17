import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Rounded surface container used throughout the app, optionally tappable.
///
/// Adds a hairline border and a soft shadow in dark mode to give cards a
/// subtle sense of depth and a premium, glassy feel.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
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

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: isDark
            ? const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x0F1B2A4A),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
      ),
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: border ??
                  Border.all(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: isDark ? 0.07 : 0.05),
                  ),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
