import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/campaign.dart';
import '../../../data/models/campaign_status.dart';
import '../../../domain/repositories/campaign_repository.dart';

part 'campaign_list_event.dart';
part 'campaign_list_state.dart';

class CampaignListBloc extends Bloc<CampaignListEvent, CampaignListState> {
  CampaignListBloc(this._repository) : super(const CampaignListState()) {
    on<CampaignListRequested>(_onRequested);
    on<CampaignListRefreshed>(_onRefreshed);
    on<CampaignSearchChanged>(_onSearchChanged);
    on<CampaignFilterChanged>(_onFilterChanged);
  }

  final CampaignRepository _repository;

  Future<void> _onRequested(
    CampaignListRequested event,
    Emitter<CampaignListState> emit,
  ) async {
    emit(state.copyWith(status: CampaignListStatus.loading));
    await _load(emit);
  }

  Future<void> _onRefreshed(
    CampaignListRefreshed event,
    Emitter<CampaignListState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<CampaignListState> emit) async {
    final result = await _repository.getCampaigns();
    result.fold(
      (failure) => emit(state.copyWith(
        status: CampaignListStatus.failure,
        errorMessage: failure.message,
      )),
      (campaigns) => emit(state.copyWith(
        status: CampaignListStatus.success,
        campaigns: campaigns,
      )),
    );
  }

  void _onSearchChanged(
    CampaignSearchChanged event,
    Emitter<CampaignListState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  void _onFilterChanged(
    CampaignFilterChanged event,
    Emitter<CampaignListState> emit,
  ) {
    emit(state.copyWith(filter: event.filter, clearFilter: event.filter == null));
  }
}
