import 'package:equatable/equatable.dart';

/// Spend for one advertising channel.
class ChannelSpend extends Equatable {
  const ChannelSpend({
    required this.channel,
    required this.spend,
    required this.impressions,
    required this.clicks,
  });

  final String channel;
  final num spend;
  final num impressions;
  final num clicks;

  factory ChannelSpend.fromJson(Map<String, dynamic> json) {
    return ChannelSpend(
      channel: json['channel'] as String? ?? '',
      spend: json['spend'] as num? ?? 0,
      impressions: json['impressions'] as num? ?? 0,
      clicks: json['clicks'] as num? ?? 0,
    );
  }

  @override
  List<Object?> get props => [channel, spend, impressions, clicks];
}

/// A ranked campaign in the "top campaigns by CTR" list.
class CampaignRank extends Equatable {
  const CampaignRank({
    required this.id,
    required this.name,
    required this.ctr,
    required this.spend,
  });

  final String id;
  final String name;
  final double ctr;
  final num spend;

  factory CampaignRank.fromJson(Map<String, dynamic> json) {
    return CampaignRank(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      ctr: (json['ctr'] as num?)?.toDouble() ?? 0,
      spend: json['spend'] as num? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, ctr, spend];
}

/// Aggregated spend summary (from `/campaigns/summary`).
class SpendSummary extends Equatable {
  const SpendSummary({
    required this.range,
    required this.totalSpend,
    required this.totalImpressions,
    required this.totalClicks,
    required this.overallCtr,
    required this.byChannel,
    required this.topCampaigns,
  });

  final String range;
  final num totalSpend;
  final num totalImpressions;
  final num totalClicks;
  final double overallCtr;
  final List<ChannelSpend> byChannel;
  final List<CampaignRank> topCampaigns;

  /// Total spend across channels, used to compute donut percentages.
  num get channelTotal =>
      byChannel.fold<num>(0, (sum, c) => sum + c.spend);

  factory SpendSummary.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>? ?? const {};
    return SpendSummary(
      range: json['range'] as String? ?? '',
      totalSpend: summary['total_spend'] as num? ?? 0,
      totalImpressions: summary['total_impressions'] as num? ?? 0,
      totalClicks: summary['total_clicks'] as num? ?? 0,
      overallCtr: (summary['overall_ctr'] as num?)?.toDouble() ?? 0,
      byChannel: (summary['by_channel'] as List<dynamic>? ?? [])
          .map((e) => ChannelSpend.fromJson(e as Map<String, dynamic>))
          .toList(),
      topCampaigns: (summary['top_campaigns'] as List<dynamic>? ?? [])
          .map((e) => CampaignRank.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        range,
        totalSpend,
        totalImpressions,
        totalClicks,
        overallCtr,
        byChannel,
        topCampaigns,
      ];
}
