import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_breakpoints.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../../core/widgets/loading_view.dart';
import '../bloc/campaign_list/campaign_list_bloc.dart';
import '../widgets/campaign_card.dart';
import '../widgets/campaign_filter_bar.dart';

class CampaignListPage extends StatelessWidget {
  const CampaignListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<CampaignListBloc>()..add(const CampaignListRequested()),
      child: const _CampaignListView(),
    );
  }
}

class _CampaignListView extends StatelessWidget {
  const _CampaignListView();

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Campaign List')),
      body: SafeArea(
        child: ResponsiveCenter(
          child: BlocBuilder<CampaignListBloc, CampaignListState>(
            builder: (context, state) {
              final bloc = context.read<CampaignListBloc>();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: CampaignFilterBar(
                      filter: state.filter,
                      onSearchChanged: (q) =>
                          bloc.add(CampaignSearchChanged(q)),
                      onFilterChanged: (f) =>
                          bloc.add(CampaignFilterChanged(f)),
                    ),
                  ),
                  Expanded(child: _buildBody(context, state, bloc)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CampaignListState state,
    CampaignListBloc bloc,
  ) {
    switch (state.status) {
      case CampaignListStatus.initial:
      case CampaignListStatus.loading:
        return const LoadingView(message: 'Loading campaigns...');
      case CampaignListStatus.failure:
        return ErrorView(
          message: state.errorMessage ?? 'Could not load campaigns.',
          onRetry: () => bloc.add(const CampaignListRequested()),
        );
      case CampaignListStatus.success:
        final campaigns = state.filteredCampaigns;
        if (campaigns.isEmpty) {
          return const EmptyView(
            title: 'No campaigns found',
            message: 'Try adjusting your search or filters.',
            icon: Icons.search_off_rounded,
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            bloc.add(const CampaignListRefreshed());
            await bloc.stream.firstWhere(
              (s) => s.status != CampaignListStatus.loading,
            );
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            itemCount: campaigns.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final campaign = campaigns[index];
              return CampaignCard(
                campaign: campaign,
                onTap: () =>
                    context.push(AppRoutes.campaignDetailPath(campaign.id)),
              );
            },
          ),
        );
    }
  }
}
