import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/daily_metric.dart';
import '../../data/models/forecast.dart';

/// Line chart rendering historical CTR (solid) and the 7-day forecast (dashed)
/// with a shaded confidence band between the lower and upper bounds.
///
/// CTR values are fractions (0.04); they are plotted as percentages (4.0).
class CtrForecastChart extends StatelessWidget {
  const CtrForecastChart({
    super.key,
    required this.history,
    required this.forecast,
  });

  final List<DailyMetric> history;
  final List<ForecastPoint> forecast;

  static const double _scale = 100; // fraction -> percent

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final histLen = history.length;

    final historySpots = [
      for (var i = 0; i < histLen; i++)
        FlSpot(i.toDouble(), history[i].ctr * _scale),
    ];

    // Connect the forecast to the last historical point for visual continuity.
    final connectX = (histLen - 1).toDouble();
    final connectY = histLen > 0 ? history.last.ctr * _scale : 0.0;

    final forecastSpots = <FlSpot>[
      if (histLen > 0) FlSpot(connectX, connectY),
      for (var j = 0; j < forecast.length; j++)
        FlSpot((histLen + j).toDouble(), forecast[j].predictedCtr * _scale),
    ];
    final lowerSpots = <FlSpot>[
      if (histLen > 0) FlSpot(connectX, connectY),
      for (var j = 0; j < forecast.length; j++)
        FlSpot((histLen + j).toDouble(), forecast[j].lowerBound * _scale),
    ];
    final upperSpots = <FlSpot>[
      if (histLen > 0) FlSpot(connectX, connectY),
      for (var j = 0; j < forecast.length; j++)
        FlSpot((histLen + j).toDouble(), forecast[j].upperBound * _scale),
    ];

    final allY = [
      ...historySpots.map((s) => s.y),
      ...lowerSpots.map((s) => s.y),
      ...upperSpots.map((s) => s.y),
    ];
    final minY = (allY.isEmpty ? 0.0 : allY.reduce((a, b) => a < b ? a : b)) - 0.5;
    final maxY = (allY.isEmpty ? 5.0 : allY.reduce((a, b) => a > b ? a : b)) + 0.5;
    final maxX = (histLen + forecast.length - 1).toDouble();

    return AspectRatio(
      aspectRatio: 1.4,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX < 1 ? 1 : maxX,
          minY: minY < 0 ? 0 : minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: ((maxY - minY) / 4).clamp(0.5, 100),
            getDrawingHorizontalLine: (_) => FlLine(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                interval: ((maxY - minY) / 4).clamp(0.5, 100),
                getTitlesWidget: (value, meta) => Text(
                  '${value.toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: (maxX / 4).clamp(1, 1000),
                getTitlesWidget: (value, meta) {
                  final label = _bottomLabel(value.toInt(), histLen);
                  if (label == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => theme.colorScheme.surface,
              getTooltipItems: (spots) => spots
                  .map((s) => LineTooltipItem(
                        '${s.y.toStringAsFixed(2)}%',
                        TextStyle(color: theme.colorScheme.onSurface),
                      ))
                  .toList(),
            ),
          ),
          lineBarsData: [
            // Upper bound (invisible line, used for the band)
            LineChartBarData(
              spots: upperSpots,
              isCurved: true,
              barWidth: 0,
              dotData: const FlDotData(show: false),
              color: Colors.transparent,
            ),
            // Lower bound + shaded band between lower and upper
            LineChartBarData(
              spots: lowerSpots,
              isCurved: true,
              barWidth: 0,
              dotData: const FlDotData(show: false),
              color: Colors.transparent,
              belowBarData: BarAreaData(show: false),
              aboveBarData: BarAreaData(
                show: true,
                applyCutOffY: false,
                color: AppColors.warning.withValues(alpha: 0.14),
              ),
            ),
            // Historical CTR (solid)
            LineChartBarData(
              spots: historySpots,
              isCurved: true,
              barWidth: 3,
              color: AppColors.primary,
              dotData: const FlDotData(show: false),
            ),
            // Forecast CTR (dashed)
            LineChartBarData(
              spots: forecastSpots,
              isCurved: true,
              barWidth: 3,
              color: AppColors.warning,
              dashArray: const [6, 4],
              dotData: const FlDotData(show: false),
            ),
          ],
          betweenBarsData: [
            BetweenBarsData(
              fromIndex: 0,
              toIndex: 1,
              color: AppColors.warning.withValues(alpha: 0.14),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the day-1 history date, the junction, and forecast dates.
  String? _bottomLabel(int index, int histLen) {
    if (index == 0 && history.isNotEmpty) {
      return _short(history.first.date);
    }
    if (index == histLen - 1 && history.isNotEmpty) {
      return _short(history.last.date);
    }
    final forecastIndex = index - histLen;
    if (forecastIndex >= 0 && forecastIndex < forecast.length) {
      return _short(forecast[forecastIndex].date);
    }
    return null;
  }

  String _short(DateTime d) =>
      '${d.day}/${d.month}';
}
