import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A [Scaffold] with an ambient gradient backdrop and soft color glows, giving
/// every screen a consistent premium feel. Falls back to a flat surface in
/// light mode.
class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [AppColors.gradientTop, AppColors.gradientBottom],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  colors: [Color(0xFFF7F9FC), Color(0xFFEDF1F6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: isDark
            ? Stack(
                children: [
                  const _Glow(
                    alignment: Alignment(1.1, -1.0),
                    color: AppColors.glowTeal,
                  ),
                  const _Glow(
                    alignment: Alignment(-1.2, -0.4),
                    color: AppColors.glowPurple,
                    opacity: 0.10,
                  ),
                  body,
                ],
              )
            : body,
      ),
    );
  }
}

/// A soft, out-of-focus radial glow used as ambient background lighting.
class _Glow extends StatelessWidget {
  const _Glow({
    required this.alignment,
    required this.color,
    this.opacity = 0.16,
  });

  final Alignment alignment;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
