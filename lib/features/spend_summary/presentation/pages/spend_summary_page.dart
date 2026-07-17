import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_breakpoints.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/section_header.dart';
import '../bloc/spend_summary_bloc.dart';
import '../widgets/channel_donut_chart.dart';
import '../widgets/kpi_card.dart';
import '../widgets/range_selector.dart';
import '../widgets/top_campaigns_list.dart';

class SpendSummaryPage extends StatelessWidget {
  const SpendSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SpendSummaryBloc>()..add(const SpendSummaryRequested()),
      child: const _SpendSummaryView(),
    );
  }
}

class _SpendSummaryView extends StatelessWidget {
  const _SpendSummaryView();

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Spend Summary')),
      body: SafeArea(
        child: ResponsiveCenter(
          child: BlocBuilder<SpendSummaryBloc, SpendSummaryState>(
            builder: (context, state) {
              final bloc = context.read<SpendSummaryBloc>();
              switch (state.status) {
                case SpendSummaryStatus.initial:
                case SpendSummaryStatus.loading:
                  return const LoadingView(message: 'Loading summary...');
                case SpendSummaryStatus.failure:
                  return ErrorView(
                    message: state.errorMessage ?? 'Could not load summary.',
                    onRetry: () => bloc.add(const SpendSummaryRequested()),
                  );
                case SpendSummaryStatus.success:
                  return _Content(state: state, bloc: bloc);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state, required this.bloc});

  final SpendSummaryState state;
  final SpendSummaryBloc bloc;

  @override
  Widget build(BuildContext context) {
    final summary = state.summary;
    if (summary == null) {
      return const EmptyView(message: 'No spend data available.');
    }

    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(SpendRangeChanged(state.range));
        await bloc.stream
            .firstWhere((s) => s.status != SpendSummaryStatus.loading);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          KpiCard(
            label: 'Total Spend',
            value: Formatters.currency(summary.totalSpend),
            caption:
                'CTR ${Formatters.ctrFromFraction(summary.overallCtr)} · ${Formatters.compact(summary.totalClicks)} clicks',
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Spend by channel'),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: ChannelDonutChart(
              channels: summary.byChannel,
              total: summary.channelTotal,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Top 3 campaigns by CTR'),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: TopCampaignsList(campaigns: summary.topCampaigns),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Date range'),
          const SizedBox(height: AppSpacing.md),
          RangeSelector(
            selected: state.range,
            onChanged: (range) => bloc.add(SpendRangeChanged(range)),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
