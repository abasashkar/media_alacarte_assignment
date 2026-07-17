import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';

/// Visual spend-vs-budget progress bar with amounts and percentage.
class SpendProgressBar extends StatelessWidget {
  const SpendProgressBar({
    super.key,
    required this.spend,
    required this.budget,
    required this.progress,
    required this.currency,
  });

  final num spend;
  final num budget;
  final double progress; // 0..1
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentLabel = Formatters.percent(progress * 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total spend',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                  children: [
                    TextSpan(text: Formatters.currency(spend, symbol: currency)),
                    TextSpan(
                      text: ' / ${Formatters.currency(budget, symbol: currency)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              percentLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Stack(
                children: [
                  Container(
                    height: 9,
                    width: double.infinity,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => Container(
                      height: 9,
                      width: constraints.maxWidth * value,
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
