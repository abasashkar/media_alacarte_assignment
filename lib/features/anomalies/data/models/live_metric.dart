import 'package:equatable/equatable.dart';

/// One campaign's last-hour metrics from `/campaigns/metrics/live`.
class LiveMetric extends Equatable {
  const LiveMetric({
    required this.id,
    required this.impressionsLastHour,
    required this.clicksLastHour,
    required this.spendLastHour,
    required this.ctrLastHour,
  });

  final String id;
  final num impressionsLastHour;
  final num clicksLastHour;
  final double spendLastHour;
  final double ctrLastHour;

  factory LiveMetric.fromJson(Map<String, dynamic> json) {
    return LiveMetric(
      id: json['id'] as String? ?? '',
      impressionsLastHour: json['impressions_last_hour'] as num? ?? 0,
      clicksLastHour: json['clicks_last_hour'] as num? ?? 0,
      spendLastHour: (json['spend_last_hour'] as num?)?.toDouble() ?? 0,
      ctrLastHour: (json['ctr_last_hour'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'impressions_last_hour': impressionsLastHour,
        'clicks_last_hour': clicksLastHour,
        'spend_last_hour': spendLastHour,
        'ctr_last_hour': ctrLastHour,
      };

  @override
  List<Object?> get props => [
        id,
        impressionsLastHour,
        clicksLastHour,
        spendLastHour,
        ctrLastHour,
      ];
}

/// A snapshot of live metrics across campaigns at a point in time.
class MetricsSnapshot extends Equatable {
  const MetricsSnapshot({
    required this.timestamp,
    required this.campaigns,
  });

  final DateTime timestamp;
  final List<LiveMetric> campaigns;

  factory MetricsSnapshot.fromJson(Map<String, dynamic> json) {
    return MetricsSnapshot(
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
              DateTime.now(),
      campaigns: (json['campaigns'] as List<dynamic>? ?? [])
          .map((e) => LiveMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'campaigns': campaigns.map((c) => c.toJson()).toList(),
      };

  @override
  List<Object?> get props => [timestamp, campaigns];
}
