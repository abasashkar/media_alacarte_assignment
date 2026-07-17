import 'package:flutter/material.dart';

/// Simple responsive helpers so screens can adapt padding and max content
/// width between phone, tablet and desktop widths.
class AppBreakpoints {
  const AppBreakpoints._();

  static const double tablet = 600;
  static const double desktop = 1024;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;

  /// Constrains content on wide screens so it stays readable and centered.
  static double contentMaxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktop) return 900;
    if (width >= tablet) return 700;
    return width;
  }
}

/// Centers and width-limits its child on large screens.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppBreakpoints.contentMaxWidth(context),
        ),
        child: child,
      ),
    );
  }
}
