/// Centralized route paths and names to avoid magic strings.
class AppRoutes {
  const AppRoutes._();

  static const String campaigns = '/campaigns';
  static const String campaignDetail = 'detail'; // relative sub-route
  static const String spendSummary = '/spend-summary';
  static const String alerts = '/alerts';
  static const String profile = '/profile';

  static String campaignDetailPath(String id) => '/campaigns/$id';
}
