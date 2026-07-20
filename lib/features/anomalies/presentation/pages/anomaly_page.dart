import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_breakpoints.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/fade_in.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/section_header.dart';
import '../bloc/anomaly_bloc.dart';
import '../widgets/alert_card.dart';
import '../widgets/live_indicator.dart';

class AnomalyPage extends StatelessWidget {
  const AnomalyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<AnomalyBloc>()..add(const AnomalyMonitoringStarted()),
      child: const _AnomalyView(),
    );
  }
}

class _AnomalyView extends StatelessWidget {
  const _AnomalyView();

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Anomaly Alerts'),
        actions: [
          // Debug-only shortcut to verify the notification pipeline
          // (permission, channel, plugin) independent of anomaly detection.
          if (kDebugMode)
            IconButton(
              tooltip: 'Send test notification',
              icon: const Icon(Icons.notification_add_outlined),
              onPressed: () {
                sl<NotificationService>().showAnomaly(
                  id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                  title: 'Test notification',
                  body: 'If you can see this, notifications are working.',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Test notification sent.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          child: BlocBuilder<AnomalyBloc, AnomalyState>(
            builder: (context, state) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  FadeIn(child: _MonitoringHeader(state: state)),
                  const SizedBox(height: AppSpacing.section),
                  const SectionHeader(title: 'Recent Anomalies'),
                  const SizedBox(height: AppSpacing.lg),
                  _buildBody(context, state),
                  const SizedBox(height: AppSpacing.section),
                  _NotificationsToggle(state: state),
                  const SizedBox(height: AppSpacing.lg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AnomalyState state) {
    if (state.status == AnomalyStatus.loading && state.anomalies.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: AppSpacing.xxl),
        child: LoadingView(message: 'Checking live metrics...'),
      );
    }
    if (state.status == AnomalyStatus.failure && state.anomalies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xxl),
        child: ErrorView(
          message: state.errorMessage ?? 'Could not check for anomalies.',
          onRetry: () =>
              context.read<AnomalyBloc>().add(const AnomalyPollTicked()),
        ),
      );
    }
    if (state.anomalies.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: AppSpacing.xxl),
        child: EmptyView(
          title: 'All clear',
          message: 'No anomalies detected in the latest metrics.',
          icon: Icons.check_circle_outline_rounded,
        ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < state.anomalies.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: FadeIn(
              delay: Duration(milliseconds: 60 * i),
              child: AlertCard(anomaly: state.anomalies[i]),
            ),
          ),
      ],
    );
  }
}

class _MonitoringHeader extends StatelessWidget {
  const _MonitoringHeader({required this.state});

  final AnomalyState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(Icons.radar_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monitoring in real-time',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  'Polling Ads API every 30 seconds',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          LiveIndicator(isLive: state.isLive),
        ],
      ),
    );
  }
}

class _NotificationsToggle extends StatelessWidget {
  const _NotificationsToggle({required this.state});

  final AnomalyState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(Icons.notifications_active_rounded,
                color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enable Push Notifications',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  'Get notified instantly when a new anomaly is detected.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Switch(
            value: state.notificationsEnabled,
            onChanged: (value) => context
                .read<AnomalyBloc>()
                .add(AnomalyNotificationsToggled(value)),
          ),
        ],
      ),
    );
  }
}
