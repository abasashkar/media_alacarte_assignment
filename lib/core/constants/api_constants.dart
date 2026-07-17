/// Central place for API base URL and endpoint builders.
///
/// The assignment lists two base URLs (Ads REST API and ML Forecast API) that
/// are identical, so a single client serves every endpoint.
class ApiConstants {
  const ApiConstants._();

  static const String baseUrl =
      'https://e5eb0d84-2b7e-4c32-98b9-233668b4e189.mock.pstmn.io/v1';

  // Ads REST API
  static const String campaigns = '/campaigns';
  static String campaignById(String id) => '/campaigns/$id';
  static String campaignHistory(String id) => '/campaigns/$id/history';
  static const String summary = '/campaigns/summary';
  static const String liveMetrics = '/campaigns/metrics/live';

  // ML Forecast API
  static const String forecastCtr = '/forecast/ctr';
  static const String anomalyDetect = '/anomaly/detect';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Live-metrics polling interval for the anomaly screen.
  static const Duration pollInterval = Duration(seconds: 30);
}
