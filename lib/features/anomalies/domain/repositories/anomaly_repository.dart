import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/anomaly.dart';

abstract class AnomalyRepository {
  /// Fetches the latest live metrics window and runs anomaly detection on it.
  Future<Either<Failure, List<Anomaly>>> checkForAnomalies();
}
