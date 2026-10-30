import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lift_log/core/models/body_progress_models.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class BodyProgressChart extends StatelessWidget {
  const BodyProgressChart({
    super.key,
    required this.entries,
    required this.weightUnit,
    required this.locale,
    required this.semanticLabel,
  });

  final List<BodyWeightEntry> entries;
  final String weightUnit;
  final String locale;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return SizedBox(height: 220.h);

    final values = entries.map((entry) => entry.weight).toList();
    final minWeight = values.reduce((a, b) => a < b ? a : b);
    final maxWeight = values.reduce((a, b) => a > b ? a : b);
    final padding = (maxWeight - minWeight).abs() < 1
        ? 1.0
        : (maxWeight - minWeight) * 0.15;
    final spots = [
      for (var index = 0; index < entries.length; index++)
        FlSpot(index.toDouble(), entries[index].weight),
    ];

    return Semantics(
      label: semanticLabel,
      child: SizedBox(
        height: 220.h,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: entries.length == 1 ? 1 : (entries.length - 1).toDouble(),
            minY: (minWeight - padding).clamp(0, double.infinity).toDouble(),
            maxY: maxWeight + padding,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: padding,
              getDrawingHorizontalLine: (_) => FlLine(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                axisNameSize: 22.h,
                axisNameWidget: AppText(
                  'weight',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 38.w,
                  getTitlesWidget: (value, meta) => AppText(
                    value.toStringAsFixed(0),
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                axisNameSize: 20.h,
                axisNameWidget: AppText(
                  'date',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
                sideTitles: SideTitles(
                  showTitles: entries.length > 1,
                  reservedSize: 34.h,
                  interval: entries.length > 6
                      ? (entries.length / 4).ceilToDouble()
                      : 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.round();
                    if (index < 0 || index >= entries.length) {
                      return const SizedBox.shrink();
                    }
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: AppText(
                        intl.DateFormat.Md(
                          locale,
                        ).format(entries[index].measuredAt),
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) => touchedSpots
                    .map(
                      (spot) => LineTooltipItem(
                        '${spot.y.toStringAsFixed(1)} $weightUnit\n${intl.DateFormat.yMMMd(locale).format(entries[spot.x.round()].measuredAt)}',
                        TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 3,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
