import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/date_range.dart';
import '../models/spend_summary.dart';

abstract class SpendRemoteDataSource {
  Future<SpendSummary> getSummary(SummaryRange range);
}

class SpendRemoteDataSourceImpl implements SpendRemoteDataSource {
  const SpendRemoteDataSourceImpl(this._client);

  final DioClient _client;

  @override
  Future<SpendSummary> getSummary(SummaryRange range) async {
    final response = await _client.get(
      ApiConstants.summary,
      queryParameters: {'range': range.apiValue},
    );
    final data = response.data;
    if (data == null || data['summary'] is! Map) {
      throw const ApiException('Malformed summary response.');
    }
    return SpendSummary.fromJson(data);
  }
}
