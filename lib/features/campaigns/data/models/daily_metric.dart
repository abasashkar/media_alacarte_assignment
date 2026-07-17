import 'package:equatable/equatable.dart';

/// One day of historical CTR data (from `/campaigns/:id/history`).
class DailyMetric extends Equatable {
  const DailyMetric({
    required this.date,
    required this.impressions,
    required this.clicks,
    required this.ctr,
  });

  final DateTime date;
  final num impressions;
  final num clicks;
  final double ctr;

  factory DailyMetric.fromJson(Map<String, dynamic> json) {
    return DailyMetric(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime(2000),
      impressions: json['impressions'] as num? ?? 0,
      clicks: json['clicks'] as num? ?? 0,
      ctr: (json['ctr'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [date, impressions, clicks, ctr];
}
