import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/repositories/spend_repository.dart';
import '../datasources/spend_remote_data_source.dart';
import '../models/date_range.dart';
import '../models/spend_summary.dart';

class SpendRepositoryImpl implements SpendRepository {
  const SpendRepositoryImpl(this._remote);

  final SpendRemoteDataSource _remote;

  @override
  Future<Either<Failure, SpendSummary>> getSummary(SummaryRange range) async {
    try {
      return Right(await _remote.getSummary(range));
    } catch (error) {
      return Left(mapErrorToFailure(error));
    }
  }
}
