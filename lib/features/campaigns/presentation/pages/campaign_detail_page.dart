import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_breakpoints.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/campaign.dart';
import '../bloc/campaign_detail/campaign_detail_bloc.dart';
import '../widgets/budget_recommendation_card.dart';
import '../widgets/campaign_thumbnail.dart';
import '../widgets/ctr_forecast_chart.dart';
import '../widgets/status_badge.dart';

class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({super.key, required this.campaignId});

  final String campaignId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CampaignDetailBloc>()
        ..add(CampaignDetailRequested(campaignId)),
      child: _CampaignDetailView(campaignId: campaignId),
    );
  }
}

class _CampaignDetailView extends StatelessWidget {
  const _CampaignDetailView({required this.campaignId});

  final String campaignId;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Campaign Detail')),
      body: SafeArea(
        child: BlocBuilder<CampaignDetailBloc, CampaignDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case CampaignDetailStatus.initial:
              case CampaignDetailStatus.loading:
                return const LoadingView(message: 'Loading campaign...');
              case CampaignDetailStatus.failure:
                return ErrorView(
                  message: state.errorMessage ?? 'Could not load campaign.',
                  onRetry: () => context
                      .read<CampaignDetailBloc>()
                      .add(CampaignDetailRequested(campaignId)),
                );
              case CampaignDetailStatus.success:
                return _Content(state: state);
            }
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state});

  final CampaignDetailState state;

  @override
  Widget build(BuildContext context) {
    final campaign = state.campaign!;
    final theme = Theme.of(context);

    return ResponsiveCenter(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Header(campaign: campaign),
          const SizedBox(height: AppSpacing.lg),
          _MetricsGrid(campaign: campaign),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'CTR: history & 7-day forecast'),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ChartLegend(),
                const SizedBox(height: AppSpacing.lg),
                CtrForecastChart(
                  history: state.history,
                  forecast: state.forecast?.points ?? const [],
                ),
              ],
            ),
          ),
          if (state.forecast?.recommendation != null) ...[
            const SizedBox(height: AppSpacing.lg),
            BudgetRecommendationCard(
              recommendation: state.forecast!.recommendation!,
            ),
          ],
          if (campaign.targetAudience != null) ...[
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Target audience'),
            const SizedBox(height: AppSpacing.md),
            _AudienceCard(campaign: campaign),
          ],
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Forecast model: ${state.forecast?.horizonDays ?? 7}-day horizon',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CampaignThumbnail(
          objective: campaign.objective,
          channel: campaign.channel,
          size: 56,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(campaign.name, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${campaign.objective} · ${campaign.channel}',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.sm),
              StatusBadge(status: campaign.status),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final items = <_Metric>[
      _Metric('Impressions', Formatters.compact(campaign.impressions)),
      _Metric('Clicks', Formatters.compact(campaign.clicks)),
      _Metric('CTR', Formatters.ctrFromFraction(campaign.ctr)),
      _Metric('Spend', Formatters.currency(campaign.spend, symbol: campaign.currency)),
      if (campaign.conversions != null)
        _Metric('Conversions', Formatters.number(campaign.conversions!)),
      if (campaign.costPerClick != null)
        _Metric('Cost / click',
            Formatters.currency(campaign.costPerClick!, symbol: campaign.currency)),
      if (campaign.costPerConversion != null)
        _Metric('Cost / conv.',
            Formatters.currency(campaign.costPerConversion!, symbol: campaign.currency)),
      _Metric('Budget used', Formatters.percent(campaign.budgetUtilization, decimals: 1)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 500 ? 4 : 2;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 1.6,
          children: items.map((m) => _MetricBox(metric: m)).toList(),
        );
      },
    );
  }
}

class _Metric {
  const _Metric(this.label, this.value);
  final String label;
  final String value;
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.metric});

  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            metric.label,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: const [
        _LegendItem(color: AppColors.primary, label: 'Historical CTR'),
        _LegendItem(
            color: AppColors.warning, label: 'Forecast CTR', dashed: true),
        _LegendItem(
            color: AppColors.warning, label: 'Confidence band', faded: true),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.dashed = false,
    this.faded = false,
  });

  final Color color;
  final String label;
  final bool dashed;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: faded ? 12 : 3,
          decoration: BoxDecoration(
            color: faded ? color.withValues(alpha: 0.2) : color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _AudienceCard extends StatelessWidget {
  const _AudienceCard({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final audience = campaign.targetAudience!;
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_alt_rounded,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Age range: ${audience.ageRange}',
                  style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Regions',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: audience.regions
                .map((r) => Chip(label: Text(r)))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Interests',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: audience.interests
                .map((i) => Chip(label: Text(i)))
                .toList(),
          ),
        ],
      ),
    );
  }
}
