import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/campaign.dart';
import '../../data/models/daily_metric.dart';
import '../../data/models/forecast.dart';

/// Contract the presentation layer depends on. Returns [Either] so the UI can
/// branch on [Failure] vs. data without dealing with exceptions.
abstract class CampaignRepository {
  Future<Either<Failure, List<Campaign>>> getCampaigns();
  Future<Either<Failure, Campaign>> getCampaign(String id);
  Future<Either<Failure, List<DailyMetric>>> getHistory(String id);
  Future<Either<Failure, ForecastResult>> forecastCtr({
    required String campaignId,
    required List<DailyMetric> history,
    int horizonDays,
  });
}
