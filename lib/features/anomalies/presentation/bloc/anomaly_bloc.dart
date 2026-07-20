import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/models/anomaly.dart';
import '../../domain/repositories/anomaly_repository.dart';

part 'anomaly_event.dart';
part 'anomaly_state.dart';

class AnomalyBloc extends Bloc<AnomalyEvent, AnomalyState> {
  AnomalyBloc({
    required AnomalyRepository repository,
    required NotificationService notifications,
  })  : _repository = repository,
        _notifications = notifications,
        super(const AnomalyState()) {
    on<AnomalyMonitoringStarted>(_onStarted);
    on<AnomalyMonitoringStopped>(_onStopped);
    on<AnomalyPollTicked>(_onPollTicked);
    on<AnomalyNotificationsToggled>(_onNotificationsToggled);
  }

  final AnomalyRepository _repository;
  final NotificationService _notifications;

  Timer? _timer;
  final Set<String> _seenAnomalyIds = {};

  Future<void> _onStarted(
    AnomalyMonitoringStarted event,
    Emitter<AnomalyState> emit,
  ) async {
    emit(state.copyWith(isLive: true, status: AnomalyStatus.loading));
    _timer?.cancel();
    _timer = Timer.periodic(
      ApiConstants.pollInterval,
      (_) => add(const AnomalyPollTicked()),
    );
    add(const AnomalyPollTicked());
  }

  void _onStopped(
    AnomalyMonitoringStopped event,
    Emitter<AnomalyState> emit,
  ) {
    _timer?.cancel();
    _timer = null;
    emit(state.copyWith(isLive: false));
  }

  Future<void> _onPollTicked(
    AnomalyPollTicked event,
    Emitter<AnomalyState> emit,
  ) async {
    final result = await _repository.checkForAnomalies();
    await result.fold(
      (failure) async {
        // Keep previously loaded anomalies visible if we already have some.
        emit(state.copyWith(
          status: state.anomalies.isEmpty
              ? AnomalyStatus.failure
              : AnomalyStatus.success,
          errorMessage: failure.message,
        ));
      },
      (anomalies) async {
        await _notifyNewAnomalies(anomalies);
        emit(state.copyWith(
          status: AnomalyStatus.success,
          anomalies: anomalies,
          lastUpdated: DateTime.now(),
        ));
      },
    );
  }

  Future<void> _notifyNewAnomalies(List<Anomaly> anomalies) async {
    // Respect the in-app toggle, but keep tracking seen IDs so re-enabling
    // notifications later doesn't replay the whole backlog.
    if (!state.notificationsEnabled) {
      _seenAnomalyIds.addAll(anomalies.map((a) => a.id));
      return;
    }
    if (anomalies.isEmpty) return;

    final firstLoad = _seenAnomalyIds.isEmpty && state.anomalies.isEmpty;

    if (firstLoad) {
      // Prime the seen-set with everything so we don't spam a notification for
      // each historical anomaly, but still surface the single most recent one
      // so the user gets an alert even when the API returns a static payload.
      _seenAnomalyIds.addAll(anomalies.map((a) => a.id));
      final mostRecent = anomalies.reduce(
        (a, b) => a.detectedAt.isAfter(b.detectedAt) ? a : b,
      );
      await _showAnomalyNotification(mostRecent);
      return;
    }

    // On subsequent polls, notify for every genuinely new anomaly ID.
    for (final anomaly in anomalies) {
      final isNew = _seenAnomalyIds.add(anomaly.id);
      if (isNew) {
        await _showAnomalyNotification(anomaly);
      }
    }
  }

  Future<void> _showAnomalyNotification(Anomaly anomaly) {
    return _notifications.showAnomaly(
      id: anomaly.id.hashCode,
      title: '${anomaly.type.label}: ${anomaly.campaignName}',
      body: anomaly.message,
    );
  }

  void _onNotificationsToggled(
    AnomalyNotificationsToggled event,
    Emitter<AnomalyState> emit,
  ) {
    emit(state.copyWith(notificationsEnabled: event.enabled));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
