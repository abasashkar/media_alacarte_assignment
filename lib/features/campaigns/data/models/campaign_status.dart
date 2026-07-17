/// Lifecycle state of a campaign as returned by the API.
enum CampaignStatus {
  active('Active'),
  paused('Paused'),
  ended('Ended');

  const CampaignStatus(this.label);

  final String label;

  static CampaignStatus fromApi(String? value) {
    return switch (value?.toLowerCase()) {
      'active' => CampaignStatus.active,
      'paused' => CampaignStatus.paused,
      'ended' => CampaignStatus.ended,
      _ => CampaignStatus.ended,
    };
  }
}
