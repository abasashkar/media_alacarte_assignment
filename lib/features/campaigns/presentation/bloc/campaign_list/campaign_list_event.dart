part of 'campaign_list_bloc.dart';

sealed class CampaignListEvent extends Equatable {
  const CampaignListEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load of the campaign list.
class CampaignListRequested extends CampaignListEvent {
  const CampaignListRequested();
}

/// Pull-to-refresh re-fetch.
class CampaignListRefreshed extends CampaignListEvent {
  const CampaignListRefreshed();
}

/// Search query changed.
class CampaignSearchChanged extends CampaignListEvent {
  const CampaignSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Status filter chip changed (null = All).
class CampaignFilterChanged extends CampaignListEvent {
  const CampaignFilterChanged(this.filter);

  final CampaignStatus? filter;

  @override
  List<Object?> get props => [filter];
}
