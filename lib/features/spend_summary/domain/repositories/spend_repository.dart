import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/date_range.dart';
import '../../data/models/spend_summary.dart';

abstract class SpendRepository {
  Future<Either<Failure, SpendSummary>> getSummary(SummaryRange range);
}
