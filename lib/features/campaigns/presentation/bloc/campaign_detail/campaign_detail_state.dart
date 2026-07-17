part of 'campaign_detail_bloc.dart';

enum CampaignDetailStatus { initial, loading, success, failure }

class CampaignDetailState extends Equatable {
  const CampaignDetailState({
    this.status = CampaignDetailStatus.initial,
    this.campaign,
    this.history = const [],
    this.forecast,
    this.errorMessage,
  });

  final CampaignDetailStatus status;
  final Campaign? campaign;
  final List<DailyMetric> history;
  final ForecastResult? forecast;
  final String? errorMessage;

  CampaignDetailState copyWith({
    CampaignDetailStatus? status,
    Campaign? campaign,
    List<DailyMetric>? history,
    ForecastResult? forecast,
    String? errorMessage,
  }) {
    return CampaignDetailState(
      status: status ?? this.status,
      campaign: campaign ?? this.campaign,
      history: history ?? this.history,
      forecast: forecast ?? this.forecast,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, campaign, history, forecast, errorMessage];
}
