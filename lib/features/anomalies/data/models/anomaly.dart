import 'package:equatable/equatable.dart';

/// Kind of anomaly detected by the ML endpoint.
enum AnomalyType {
  spendSpike('spend_spike', 'Spend Spike'),
  ctrDrop('ctr_drop', 'CTR Drop'),
  unknown('unknown', 'Anomaly');

  const AnomalyType(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static AnomalyType fromApi(String? value) {
    return switch (value) {
      'spend_spike' => AnomalyType.spendSpike,
      'ctr_drop' => AnomalyType.ctrDrop,
      _ => AnomalyType.unknown,
    };
  }
}

/// A single detected anomaly (from `POST /anomaly/detect`).
class Anomaly extends Equatable {
  const Anomaly({
    required this.id,
    required this.campaignId,
    required this.campaignName,
    required this.detectedAt,
    required this.type,
    required this.severity,
    required this.metric,
    required this.actualValue,
    required this.expectedValue,
    required this.deviationPercent,
    required this.message,
  });

  final String id;
  final String campaignId;
  final String campaignName;
  final DateTime detectedAt;
  final AnomalyType type;
  final String severity; // low | medium | high
  final String metric;
  final double actualValue;
  final double expectedValue;
  final double deviationPercent;
  final String message;

  bool get isSpend => type == AnomalyType.spendSpike;

  factory Anomaly.fromJson(Map<String, dynamic> json) {
    return Anomaly(
      id: json['id'] as String? ?? '',
      campaignId: json['campaign_id'] as String? ?? '',
      campaignName: json['campaign_name'] as String? ?? '',
      detectedAt: DateTime.tryParse(json['detected_at'] as String? ?? '') ??
          DateTime.now(),
      type: AnomalyType.fromApi(json['type'] as String?),
      severity: json['severity'] as String? ?? 'low',
      metric: json['metric'] as String? ?? '',
      actualValue: (json['actual_value'] as num?)?.toDouble() ?? 0,
      expectedValue: (json['expected_value'] as num?)?.toDouble() ?? 0,
      deviationPercent: (json['deviation_percent'] as num?)?.toDouble() ?? 0,
      message: json['message'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        campaignId,
        campaignName,
        detectedAt,
        type,
        severity,
        metric,
        actualValue,
        expectedValue,
        deviationPercent,
        message,
      ];
}
