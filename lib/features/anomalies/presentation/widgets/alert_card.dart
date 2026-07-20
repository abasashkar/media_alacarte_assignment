import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/anomaly.dart';

/// Color-coded anomaly card: red for a spend spike, amber for a CTR drop.
class AlertCard extends StatelessWidget {
  const AlertCard({super.key, required this.anomaly});

  final Anomaly anomaly;

  Color get _color => anomaly.isSpend ? AppColors.danger : AppColors.warning;

  String _formatValue(double value) {
    return anomaly.isSpend
        ? Formatters.currency(value)
        : Formatters.ctrFromFraction(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.cardTheme.color ?? theme.colorScheme.surface;
    final radius = BorderRadius.circular(AppSpacing.radiusXl);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            // Left-tinted gradient fill (subtle, fades quickly to surface).
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.alphaBlend(
                        _color.withValues(alpha: 0.08),
                        surface,
                      ),
                      surface,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.45],
                  ),
                ),
              ),
            ),
            // Colored accent bar on the left edge.
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 4, color: _color),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _buildContent(context, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  anomaly.isSpend
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: _color,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _color.withValues(alpha: 0.14),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                      child: Text(
                        anomaly.type.label.toUpperCase(),
                        style: TextStyle(
                          color: _color,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(anomaly.campaignName,
                        style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
              Text(
                Formatters.timeAgo(anomaly.detectedAt),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            anomaly.message,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: anomaly.isSpend ? 'Actual spend' : 'Actual CTR',
                  value: _formatValue(anomaly.actualValue),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatBox(
                  label: 'Expected',
                  value: _formatValue(anomaly.expectedValue),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatBox(
                  label: 'Change',
                  value: Formatters.signedPercent(anomaly.deviationPercent),
                  valueColor: _color,
                ),
              ),
            ],
          ),
        ],
      );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
