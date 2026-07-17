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
    if (!state.notificationsEnabled) {
      _seenAnomalyIds.addAll(anomalies.map((a) => a.id));
      return;
    }
    // On the very first successful load we prime the seen-set without notifying
    // for every historical anomaly.
    final firstLoad = _seenAnomalyIds.isEmpty && state.anomalies.isEmpty;
    for (final anomaly in anomalies) {
      final isNew = _seenAnomalyIds.add(anomaly.id);
      if (isNew && !firstLoad) {
        await _notifications.showAnomaly(
          id: anomaly.id.hashCode,
          title: '${anomaly.type.label}: ${anomaly.campaignName}',
          body: anomaly.message,
        );
      }
    }
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
