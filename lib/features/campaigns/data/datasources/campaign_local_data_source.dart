import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/campaign.dart';

/// Caches the last successfully fetched campaign list so the list screen can
/// render offline (bonus requirement).
abstract class CampaignLocalDataSource {
  Future<void> cacheCampaigns(List<Campaign> campaigns);
  List<Campaign>? getCachedCampaigns();
}

class CampaignLocalDataSourceImpl implements CampaignLocalDataSource {
  const CampaignLocalDataSourceImpl(this._prefs);

  static const _key = 'cached_campaigns';

  final SharedPreferences _prefs;

  @override
  Future<void> cacheCampaigns(List<Campaign> campaigns) async {
    final raw = jsonEncode(campaigns.map(_toCacheJson).toList());
    await _prefs.setString(_key, raw);
  }

  @override
  List<Campaign>? getCachedCampaigns() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => Campaign.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _toCacheJson(Campaign c) => {
        'id': c.id,
        'name': c.name,
        'status': c.status.label,
        'objective': c.objective,
        'channel': c.channel,
        'budget': c.budget,
        'spend': c.spend,
        'impressions': c.impressions,
        'clicks': c.clicks,
        'ctr': c.ctr,
        'budget_utilization': c.budgetUtilization,
        'currency': c.currency,
        'start_date': c.startDate?.toIso8601String(),
        'end_date': c.endDate?.toIso8601String(),
        'thumbnail': c.thumbnail,
      };
}
