import 'package:intl/intl.dart';

/// Presentation-only formatting helpers. Kept out of widgets so formatting is
/// consistent and testable across the app.
class Formatters {
  const Formatters._();

  static final NumberFormat _compact = NumberFormat.compact(locale: 'en_US');
  static final NumberFormat _decimal = NumberFormat.decimalPattern('en_US');
  static final DateFormat _dayMonthYear = DateFormat('dd MMM yyyy');
  static final DateFormat _dayMonth = DateFormat('dd MMM');

  /// e.g. 7800 -> "7,800 SAR".
  static String currency(num value, {String symbol = 'SAR'}) {
    return '${_decimal.format(value.round())} $symbol';
  }

  /// e.g. 250000 -> "250K".
  static String compact(num value) => _compact.format(value);

  /// e.g. 1840000 -> "1,840,000".
  static String number(num value) => _decimal.format(value);

  /// A CTR stored as a fraction (0.0248) -> "2.48%".
  static String ctrFromFraction(num fraction, {int decimals = 2}) {
    return '${(fraction * 100).toStringAsFixed(decimals)}%';
  }

  /// A percentage already expressed in whole units (55.0) -> "55%".
  static String percent(num value, {int decimals = 0}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Signed percentage, e.g. -38 -> "-38%", 72 -> "+72%".
  static String signedPercent(num value, {int decimals = 0}) {
    final sign = value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(decimals)}%';
  }

  static String date(DateTime date) => _dayMonthYear.format(date);

  static String shortDate(DateTime date) => _dayMonth.format(date);

  /// Relative "time ago" label for anomaly cards, e.g. "2m ago".
  static String timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
