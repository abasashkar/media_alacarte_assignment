part of 'anomaly_bloc.dart';

enum AnomalyStatus { initial, loading, success, failure }

class AnomalyState extends Equatable {
  const AnomalyState({
    this.status = AnomalyStatus.initial,
    this.anomalies = const [],
    this.isLive = false,
    this.notificationsEnabled = true,
    this.lastUpdated,
    this.errorMessage,
  });

  final AnomalyStatus status;
  final List<Anomaly> anomalies;
  final bool isLive;
  final bool notificationsEnabled;
  final DateTime? lastUpdated;
  final String? errorMessage;

  AnomalyState copyWith({
    AnomalyStatus? status,
    List<Anomaly>? anomalies,
    bool? isLive,
    bool? notificationsEnabled,
    DateTime? lastUpdated,
    String? errorMessage,
  }) {
    return AnomalyState(
      status: status ?? this.status,
      anomalies: anomalies ?? this.anomalies,
      isLive: isLive ?? this.isLive,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        anomalies,
        isLive,
        notificationsEnabled,
        lastUpdated,
        errorMessage,
      ];
}
