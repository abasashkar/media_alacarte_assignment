import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/campaign.dart';
import '../../../data/models/daily_metric.dart';
import '../../../data/models/forecast.dart';
import '../../../domain/repositories/campaign_repository.dart';

part 'campaign_detail_event.dart';
part 'campaign_detail_state.dart';

class CampaignDetailBloc
    extends Bloc<CampaignDetailEvent, CampaignDetailState> {
  CampaignDetailBloc(this._repository)
      : super(const CampaignDetailState()) {
    on<CampaignDetailRequested>(_onRequested);
  }

  final CampaignRepository _repository;

  Future<void> _onRequested(
    CampaignDetailRequested event,
    Emitter<CampaignDetailState> emit,
  ) async {
    emit(state.copyWith(status: CampaignDetailStatus.loading));

    final campaignResult = await _repository.getCampaign(event.id);
    final campaign = campaignResult.fold((_) => null, (c) => c);
    if (campaign == null) {
      emit(state.copyWith(
        status: CampaignDetailStatus.failure,
        errorMessage:
            campaignResult.fold((f) => f.message, (_) => null),
      ));
      return;
    }

    final historyResult = await _repository.getHistory(event.id);
    final history = historyResult.fold((_) => <DailyMetric>[], (h) => h);
    if (historyResult.isLeft()) {
      emit(state.copyWith(
        status: CampaignDetailStatus.failure,
        campaign: campaign,
        errorMessage: historyResult.fold((f) => f.message, (_) => null),
      ));
      return;
    }

    final forecastResult = await _repository.forecastCtr(
      campaignId: event.id,
      history: history,
    );

    forecastResult.fold(
      (failure) => emit(state.copyWith(
        status: CampaignDetailStatus.failure,
        campaign: campaign,
        history: history,
        errorMessage: failure.message,
      )),
      (forecast) => emit(state.copyWith(
        status: CampaignDetailStatus.success,
        campaign: campaign,
        history: history,
        forecast: forecast,
      )),
    );
  }
}
