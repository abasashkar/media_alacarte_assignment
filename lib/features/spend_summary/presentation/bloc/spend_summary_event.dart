part of 'spend_summary_bloc.dart';

sealed class SpendSummaryEvent extends Equatable {
  const SpendSummaryEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load using the currently selected range.
class SpendSummaryRequested extends SpendSummaryEvent {
  const SpendSummaryRequested();
}

/// Range chip changed; triggers a re-fetch.
class SpendRangeChanged extends SpendSummaryEvent {
  const SpendRangeChanged(this.range);

  final SummaryRange range;

  @override
  List<Object?> get props => [range];
}
