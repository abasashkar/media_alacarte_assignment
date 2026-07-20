import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A single shimmering placeholder block used to build skeleton screens.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = AppSpacing.radiusSm,
    required this.shimmer,
  });

  final double? width;
  final double height;
  final double radius;

  /// Animation value in the 0..1 range driving the shimmer highlight sweep.
  final double shimmer;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final base = onSurface.withValues(alpha: 0.06);
    final highlight = onSurface.withValues(alpha: 0.12);
    final t = shimmer;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment(-1 - t, 0),
          end: Alignment(1 - t, 0),
          colors: [base, highlight, base],
          stops: const [0.35, 0.5, 0.65],
        ),
      ),
    );
  }
}

/// Animated wrapper that drives a repeating shimmer for its [builder].
class Shimmer extends StatefulWidget {
  const Shimmer({super.key, required this.builder});

  final Widget Function(BuildContext context, double shimmer) builder;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(context, _controller.value * 2),
    );
  }
}

/// Skeleton placeholder that mimics the campaign card layout while loading.
class CampaignCardSkeleton extends StatelessWidget {
  const CampaignCardSkeleton({super.key, required this.shimmer});

  final double shimmer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(
                width: 44,
                height: 44,
                radius: AppSpacing.radiusMd,
                shimmer: shimmer,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 160, height: 15, shimmer: shimmer),
                    const SizedBox(height: AppSpacing.sm),
                    SkeletonBox(width: 90, height: 12, shimmer: shimmer),
                  ],
                ),
              ),
              SkeletonBox(
                width: 68,
                height: 24,
                radius: AppSpacing.radiusPill,
                shimmer: shimmer,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SkeletonBox(
            height: 12,
            radius: AppSpacing.radiusPill,
            shimmer: shimmer,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: SkeletonBox(height: 64, shimmer: shimmer)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: SkeletonBox(height: 64, shimmer: shimmer)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: SkeletonBox(height: 64, shimmer: shimmer)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Full list of campaign card skeletons shown during the initial load.
class CampaignListSkeleton extends StatelessWidget {
  const CampaignListSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      builder: (context, shimmer) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, __) => CampaignCardSkeleton(shimmer: shimmer),
      ),
    );
  }
}
