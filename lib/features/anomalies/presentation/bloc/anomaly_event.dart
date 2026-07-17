part of 'anomaly_bloc.dart';

sealed class AnomalyEvent extends Equatable {
  const AnomalyEvent();

  @override
  List<Object?> get props => [];
}

/// Start polling live metrics every 30 seconds.
class AnomalyMonitoringStarted extends AnomalyEvent {
  const AnomalyMonitoringStarted();
}

/// Stop polling (e.g. when the screen is disposed).
class AnomalyMonitoringStopped extends AnomalyEvent {
  const AnomalyMonitoringStopped();
}

/// Internal tick fired by the polling timer (and once immediately on start).
class AnomalyPollTicked extends AnomalyEvent {
  const AnomalyPollTicked();
}

/// Toggle whether local push notifications fire for new anomalies.
class AnomalyNotificationsToggled extends AnomalyEvent {
  const AnomalyNotificationsToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
