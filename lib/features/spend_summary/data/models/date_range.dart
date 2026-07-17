/// Date range options for the spend summary dashboard.
enum SummaryRange {
  last7('last_7_days', 'Last 7 Days'),
  last14('last_14_days', 'Last 14 Days'),
  last30('last_30_days', 'Last 30 Days');

  const SummaryRange(this.apiValue, this.label);

  final String apiValue;
  final String label;
}
