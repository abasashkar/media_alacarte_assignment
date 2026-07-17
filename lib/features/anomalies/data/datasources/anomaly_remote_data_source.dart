import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/anomaly.dart';
import '../models/live_metric.dart';

abstract class AnomalyRemoteDataSource {
  Future<MetricsSnapshot> getLiveMetrics();
  Future<List<Anomaly>> detectAnomalies(MetricsSnapshot snapshot);
}

class AnomalyRemoteDataSourceImpl implements AnomalyRemoteDataSource {
  const AnomalyRemoteDataSourceImpl(this._client);

  final DioClient _client;

  @override
  Future<MetricsSnapshot> getLiveMetrics() async {
    final response = await _client.get(ApiConstants.liveMetrics);
    final data = response.data;
    if (data == null || data['campaigns'] is! List) {
      throw const ApiException('Malformed live metrics response.');
    }
    return MetricsSnapshot.fromJson(data);
  }

  @override
  Future<List<Anomaly>> detectAnomalies(MetricsSnapshot snapshot) async {
    final response = await _client.post(
      ApiConstants.anomalyDetect,
      data: snapshot.toJson(),
    );
    final data = response.data;
    if (data == null || data['anomalies'] is! List) {
      throw const ApiException('Malformed anomaly response.');
    }
    return (data['anomalies'] as List)
        .map((e) => Anomaly.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
