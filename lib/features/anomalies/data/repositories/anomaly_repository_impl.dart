import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/repositories/anomaly_repository.dart';
import '../datasources/anomaly_remote_data_source.dart';
import '../models/anomaly.dart';

class AnomalyRepositoryImpl implements AnomalyRepository {
  const AnomalyRepositoryImpl(this._remote);

  final AnomalyRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<Anomaly>>> checkForAnomalies() async {
    try {
      final snapshot = await _remote.getLiveMetrics();
      final anomalies = await _remote.detectAnomalies(snapshot);
      return Right(anomalies);
    } catch (error) {
      return Left(mapErrorToFailure(error));
    }
  }
}
