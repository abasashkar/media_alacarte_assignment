import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/campaign.dart';
import 'campaign_thumbnail.dart';
import 'metric_tile.dart';
import 'spend_progress_bar.dart';
import 'status_badge.dart';

/// Full campaign card used on the list screen.
class CampaignCard extends StatelessWidget {
  const CampaignCard({super.key, required this.campaign, this.onTap});

  final Campaign campaign;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CampaignThumbnail(
                objective: campaign.objective,
                channel: campaign.channel,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      campaign.objective,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              StatusBadge(status: campaign.status),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SpendProgressBar(
            spend: campaign.spend,
            budget: campaign.budget,
            progress: campaign.spendProgress,
            currency: campaign.currency,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  icon: Icons.visibility_outlined,
                  value: Formatters.compact(campaign.impressions),
                  label: 'Impressions',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: MetricTile(
                  icon: Icons.ads_click_rounded,
                  value: Formatters.compact(campaign.clicks),
                  label: 'Clicks',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: MetricTile(
                  icon: Icons.trending_up_rounded,
                  value: Formatters.ctrFromFraction(campaign.ctr),
                  label: 'CTR',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _IconLabel(
                  icon: Icons.calendar_today_rounded,
                  label: 'Start date',
                  value: campaign.startDate == null
                      ? '-'
                      : Formatters.date(campaign.startDate!),
                ),
              ),
              Expanded(
                child: _IconLabel(
                  icon: Icons.wifi_tethering_rounded,
                  label: 'Channel',
                  value: campaign.channel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconLabel extends StatelessWidget {
  const _IconLabel({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            Text(value, style: theme.textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}
