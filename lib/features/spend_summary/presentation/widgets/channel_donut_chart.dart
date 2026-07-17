import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/spend_summary.dart';

/// Donut chart of spend by channel with a percentage legend.
class ChannelDonutChart extends StatelessWidget {
  const ChannelDonutChart({
    super.key,
    required this.channels,
    required this.total,
  });

  final List<ChannelSpend> channels;
  final num total;

  static Color colorFor(String channel) {
    return switch (channel.toLowerCase()) {
      'search' => AppColors.channelSearch,
      'social' => AppColors.channelSocial,
      'display' => AppColors.channelDisplay,
      _ => AppColors.neutral,
    };
  }

  @override
  Widget build(BuildContext context) {
    final safeTotal = total <= 0 ? 1 : total;
    return Row(
      children: [
        SizedBox(
          width: 130,
          height: 130,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 38,
              sections: channels.map((c) {
                final pct = (c.spend / safeTotal) * 100;
                return PieChartSectionData(
                  value: c.spend.toDouble(),
                  color: colorFor(c.channel),
                  radius: 18,
                  showTitle: pct >= 12,
                  title: '${pct.toStringAsFixed(0)}%',
                  titleStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Column(
            children: channels.map((c) {
              final pct = (c.spend / safeTotal) * 100;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colorFor(c.channel),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        c.channel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      Formatters.percent(pct),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
