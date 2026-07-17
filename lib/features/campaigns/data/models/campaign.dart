import 'package:equatable/equatable.dart';

import 'campaign_status.dart';
import 'target_audience.dart';

/// A single ad campaign.
///
/// The list endpoint returns the common fields; the detail endpoint adds
/// [conversions], [costPerClick], [costPerConversion], [dailyBudget] and
/// [targetAudience], which are therefore nullable.
class Campaign extends Equatable {
  const Campaign({
    required this.id,
    required this.name,
    required this.status,
    required this.objective,
    required this.channel,
    required this.budget,
    required this.spend,
    required this.impressions,
    required this.clicks,
    required this.ctr,
    required this.budgetUtilization,
    required this.currency,
    this.startDate,
    this.endDate,
    this.thumbnail,
    this.conversions,
    this.costPerClick,
    this.costPerConversion,
    this.dailyBudget,
    this.targetAudience,
  });

  final String id;
  final String name;
  final CampaignStatus status;
  final String objective;
  final String channel;
  final num budget;
  final num spend;
  final num impressions;
  final num clicks;
  final double ctr;
  final double budgetUtilization;
  final String currency;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? thumbnail;

  // Detail-only fields.
  final num? conversions;
  final num? costPerClick;
  final num? costPerConversion;
  final num? dailyBudget;
  final TargetAudience? targetAudience;

  /// Spend as a 0..1 fraction of the budget, clamped for the progress bar.
  double get spendProgress {
    if (budget <= 0) return 0;
    return (spend / budget).clamp(0.0, 1.0).toDouble();
  }

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed campaign',
      status: CampaignStatus.fromApi(json['status'] as String?),
      objective: json['objective'] as String? ?? '',
      channel: json['channel'] as String? ?? '',
      budget: json['budget'] as num? ?? 0,
      spend: json['spend'] as num? ?? 0,
      impressions: json['impressions'] as num? ?? 0,
      clicks: json['clicks'] as num? ?? 0,
      ctr: (json['ctr'] as num?)?.toDouble() ?? 0,
      budgetUtilization:
          (json['budget_utilization'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'SAR',
      startDate: DateTime.tryParse(json['start_date'] as String? ?? ''),
      endDate: DateTime.tryParse(json['end_date'] as String? ?? ''),
      thumbnail: json['thumbnail'] as String?,
      conversions: json['conversions'] as num?,
      costPerClick: json['cost_per_click'] as num?,
      costPerConversion: json['cost_per_conversion'] as num?,
      dailyBudget: json['daily_budget'] as num?,
      targetAudience: json['target_audience'] == null
          ? null
          : TargetAudience.fromJson(
              json['target_audience'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        objective,
        channel,
        budget,
        spend,
        impressions,
        clicks,
        ctr,
        budgetUtilization,
        currency,
        startDate,
        endDate,
        thumbnail,
        conversions,
        costPerClick,
        costPerConversion,
        dailyBudget,
        targetAudience,
      ];
}
