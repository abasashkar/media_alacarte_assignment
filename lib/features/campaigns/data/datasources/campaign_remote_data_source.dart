import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/campaign.dart';
import '../models/daily_metric.dart';
import '../models/forecast.dart';

/// Handles the raw HTTP calls for the campaigns feature and maps JSON into
/// typed models. Throws [ApiException] on any failure.
abstract class CampaignRemoteDataSource {
  Future<List<Campaign>> getCampaigns();
  Future<Campaign> getCampaign(String id);
  Future<List<DailyMetric>> getHistory(String id);
  Future<ForecastResult> forecastCtr({
    required String campaignId,
    required List<DailyMetric> history,
    int horizonDays,
  });
}

class CampaignRemoteDataSourceImpl implements CampaignRemoteDataSource {
  const CampaignRemoteDataSourceImpl(this._client);

  final DioClient _client;

  @override
  Future<List<Campaign>> getCampaigns() async {
    final response = await _client.get(ApiConstants.campaigns);
    final data = response.data;
    if (data == null || data['campaigns'] is! List) {
      throw const ApiException('Malformed campaigns response.');
    }
    return (data['campaigns'] as List)
        .map((e) => Campaign.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Campaign> getCampaign(String id) async {
    final response = await _client.get(ApiConstants.campaignById(id));
    final data = response.data;
    if (data == null || data['campaign'] is! Map) {
      throw const ApiException('Malformed campaign detail response.');
    }
    return Campaign.fromJson(data['campaign'] as Map<String, dynamic>);
  }

  @override
  Future<List<DailyMetric>> getHistory(String id) async {
    final response = await _client.get(ApiConstants.campaignHistory(id));
    final data = response.data;
    if (data == null || data['history'] is! List) {
      throw const ApiException('Malformed history response.');
    }
    return (data['history'] as List)
        .map((e) => DailyMetric.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ForecastResult> forecastCtr({
    required String campaignId,
    required List<DailyMetric> history,
    int horizonDays = 7,
  }) async {
    final response = await _client.post(
      ApiConstants.forecastCtr,
      data: {
        'campaign_id': campaignId,
        'history': history
            .map((m) => {
                  'date': m.date.toIso8601String().split('T').first,
                  'ctr': m.ctr,
                })
            .toList(),
        'horizon_days': horizonDays,
      },
    );
    final data = response.data;
    if (data == null || data['forecast'] is! List) {
      throw const ApiException('Malformed forecast response.');
    }
    return ForecastResult.fromJson(data);
  }
}
