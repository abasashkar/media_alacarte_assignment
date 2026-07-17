import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/date_range.dart';
import '../../data/models/spend_summary.dart';
import '../../domain/repositories/spend_repository.dart';

part 'spend_summary_event.dart';
part 'spend_summary_state.dart';

class SpendSummaryBloc extends Bloc<SpendSummaryEvent, SpendSummaryState> {
  SpendSummaryBloc(this._repository) : super(const SpendSummaryState()) {
    on<SpendSummaryRequested>(_onRequested);
    on<SpendRangeChanged>(_onRangeChanged);
  }

  final SpendRepository _repository;

  Future<void> _onRequested(
    SpendSummaryRequested event,
    Emitter<SpendSummaryState> emit,
  ) async {
    await _load(state.range, emit);
  }

  Future<void> _onRangeChanged(
    SpendRangeChanged event,
    Emitter<SpendSummaryState> emit,
  ) async {
    emit(state.copyWith(range: event.range));
    await _load(event.range, emit);
  }

  Future<void> _load(
    SummaryRange range,
    Emitter<SpendSummaryState> emit,
  ) async {
    emit(state.copyWith(status: SpendSummaryStatus.loading));
    final result = await _repository.getSummary(range);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SpendSummaryStatus.failure,
        errorMessage: failure.message,
      )),
      (summary) => emit(state.copyWith(
        status: SpendSummaryStatus.success,
        summary: summary,
      )),
    );
  }
}
