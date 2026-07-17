part of 'spend_summary_bloc.dart';

enum SpendSummaryStatus { initial, loading, success, failure }

class SpendSummaryState extends Equatable {
  const SpendSummaryState({
    this.status = SpendSummaryStatus.initial,
    this.range = SummaryRange.last7,
    this.summary,
    this.errorMessage,
  });

  final SpendSummaryStatus status;
  final SummaryRange range;
  final SpendSummary? summary;
  final String? errorMessage;

  SpendSummaryState copyWith({
    SpendSummaryStatus? status,
    SummaryRange? range,
    SpendSummary? summary,
    String? errorMessage,
  }) {
    return SpendSummaryState(
      status: status ?? this.status,
      range: range ?? this.range,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, range, summary, errorMessage];
}
