part of 'campaign_detail_bloc.dart';

sealed class CampaignDetailEvent extends Equatable {
  const CampaignDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load the campaign detail, 30-day history, and CTR forecast for [id].
class CampaignDetailRequested extends CampaignDetailEvent {
  const CampaignDetailRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
