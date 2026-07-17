import 'package:equatable/equatable.dart';

/// A single forecasted CTR point with its confidence band.
class ForecastPoint extends Equatable {
  const ForecastPoint({
    required this.date,
    required this.predictedCtr,
    required this.lowerBound,
    required this.upperBound,
  });

  final DateTime date;
  final double predictedCtr;
  final double lowerBound;
  final double upperBound;

  factory ForecastPoint.fromJson(Map<String, dynamic> json) {
    return ForecastPoint(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime(2000),
      predictedCtr: (json['predicted_ctr'] as num?)?.toDouble() ?? 0,
      lowerBound: (json['lower_bound'] as num?)?.toDouble() ?? 0,
      upperBound: (json['upper_bound'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [date, predictedCtr, lowerBound, upperBound];
}

/// Budget/creative recommendation attached to a forecast response.
class ForecastRecommendation extends Equatable {
  const ForecastRecommendation({
    required this.trend,
    required this.changePercent,
    required this.message,
  });

  final String trend; // upward | downward | stable
  final double changePercent;
  final String message;

  bool get isPositive => changePercent >= 0;

  factory ForecastRecommendation.fromJson(Map<String, dynamic> json) {
    return ForecastRecommendation(
      trend: json['trend'] as String? ?? 'stable',
      changePercent: (json['change_percent'] as num?)?.toDouble() ?? 0,
      message: json['message'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [trend, changePercent, message];
}

/// Full response from `POST /forecast/ctr`.
class ForecastResult extends Equatable {
  const ForecastResult({
    required this.points,
    required this.horizonDays,
    this.recommendation,
  });

  final List<ForecastPoint> points;
  final int horizonDays;
  final ForecastRecommendation? recommendation;

  factory ForecastResult.fromJson(Map<String, dynamic> json) {
    return ForecastResult(
      horizonDays: json['horizon_days'] as int? ?? 7,
      points: (json['forecast'] as List<dynamic>? ?? [])
          .map((e) => ForecastPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendation: json['recommendation'] == null
          ? null
          : ForecastRecommendation.fromJson(
              json['recommendation'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [points, horizonDays, recommendation];
}
