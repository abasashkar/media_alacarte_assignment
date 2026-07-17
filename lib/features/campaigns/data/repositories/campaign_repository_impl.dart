import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/repositories/campaign_repository.dart';
import '../datasources/campaign_local_data_source.dart';
import '../datasources/campaign_remote_data_source.dart';
import '../models/campaign.dart';
import '../models/daily_metric.dart';
import '../models/forecast.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  const CampaignRepositoryImpl({
    required CampaignRemoteDataSource remote,
    required CampaignLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final CampaignRemoteDataSource _remote;
  final CampaignLocalDataSource _local;

  @override
  Future<Either<Failure, List<Campaign>>> getCampaigns() async {
    try {
      final campaigns = await _remote.getCampaigns();
      await _local.cacheCampaigns(campaigns);
      return Right(campaigns);
    } catch (error) {
      // Fall back to the cached list when offline so the app still renders.
      final cached = _local.getCachedCampaigns();
      if (cached != null && cached.isNotEmpty) {
        return Right(cached);
      }
      return Left(mapErrorToFailure(error));
    }
  }

  @override
  Future<Either<Failure, Campaign>> getCampaign(String id) async {
    try {
      return Right(await _remote.getCampaign(id));
    } catch (error) {
      return Left(mapErrorToFailure(error));
    }
  }

  @override
  Future<Either<Failure, List<DailyMetric>>> getHistory(String id) async {
    try {
      return Right(await _remote.getHistory(id));
    } catch (error) {
      return Left(mapErrorToFailure(error));
    }
  }

  @override
  Future<Either<Failure, ForecastResult>> forecastCtr({
    required String campaignId,
    required List<DailyMetric> history,
    int horizonDays = 7,
  }) async {
    try {
      return Right(await _remote.forecastCtr(
        campaignId: campaignId,
        history: history,
        horizonDays: horizonDays,
      ));
    } catch (error) {
      return Left(mapErrorToFailure(error));
    }
  }
}
