part of 'campaign_list_bloc.dart';

enum CampaignListStatus { initial, loading, success, failure }

class CampaignListState extends Equatable {
  const CampaignListState({
    this.status = CampaignListStatus.initial,
    this.campaigns = const [],
    this.query = '',
    this.filter,
    this.errorMessage,
  });

  final CampaignListStatus status;
  final List<Campaign> campaigns;
  final String query;
  final CampaignStatus? filter;
  final String? errorMessage;

  /// Campaigns after applying the active search query and status filter.
  List<Campaign> get filteredCampaigns {
    return campaigns.where((c) {
      final matchesFilter = filter == null || c.status == filter;
      final matchesQuery = query.isEmpty ||
          c.name.toLowerCase().contains(query.toLowerCase()) ||
          c.channel.toLowerCase().contains(query.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();
  }

  /// True when loaded successfully but the filtered result is empty.
  bool get isEmpty =>
      status == CampaignListStatus.success && filteredCampaigns.isEmpty;

  CampaignListState copyWith({
    CampaignListStatus? status,
    List<Campaign>? campaigns,
    String? query,
    CampaignStatus? filter,
    bool clearFilter = false,
    String? errorMessage,
  }) {
    return CampaignListState(
      status: status ?? this.status,
      campaigns: campaigns ?? this.campaigns,
      query: query ?? this.query,
      filter: clearFilter ? null : (filter ?? this.filter),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, campaigns, query, filter, errorMessage];
}
