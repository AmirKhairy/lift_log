import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/machine_details/presentation/widgets/volume_legend_item.dart';

class MachineDetailsVolumeChart extends StatelessWidget {
  const MachineDetailsVolumeChart({super.key, required this.history});

  final List<MachineWorkoutHistoryItem> history;

  @override
  Widget build(BuildContext context) {
    final chartHistory = history.reversed.toList();
    final sessionVolumes = chartHistory
        .map((item) => item.totalVolume)
        .toList();
    var cumulativeVolume = 0.0;
    final muscleVolumes = sessionVolumes.map((volume) {
      cumulativeVolume += volume;
      return cumulativeVolume;
    }).toList();
    final maxVolume = [
      ...sessionVolumes,
      ...muscleVolumes,
    ].fold<double>(0, (max, value) => value > max ? value : max);
    final chartMax = maxVolume == 0 ? 1.0 : maxVolume * 1.2;
    final primary = context.theme.colorScheme.primary;
    final secondary = context.theme.colorScheme.error;
    final volumeUnit = 'weight_unit'.tr;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'volume_progress',
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
          SizedBox(height: AppSpacing.xs.h),
          Row(
            children: [
              VolumeLegendItem(
                color: primary,
                label: 'exercise_volume',
                unit: volumeUnit,
              ),
              SizedBox(width: AppSpacing.md.w),
              VolumeLegendItem(
                color: secondary,
                label: 'muscle_volume',
                unit: volumeUnit,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs.h),
          AppText(
            'volume_chart_explanation',
            color: context.appColors.subtitle,
            fontSize: 11.sp,
            maxLines: 3,
          ),
          SizedBox(height: AppSpacing.md.h),
          SizedBox(
            height: 220.h,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: chartMax,
                alignment: BarChartAlignment.spaceAround,
                groupsSpace: 12.w,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: context.appColors.border.withValues(alpha: 0.45),
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
                    axisNameSize: 28.h,
                    axisNameWidget: Text(
                      '${'volume'.tr} ($volumeUnit)',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42.w,
                      getTitlesWidget: (value, _) => AppText(
                        _formatNumber(value),
                        style: TextStyle(fontSize: 9.sp),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameSize: 22.h,
                    axisNameWidget: Text(
                      'date'.tr,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32.h,
                      interval: history.length > 6
                          ? (history.length / 4).ceilToDouble()
                          : 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.round();
                        if (index < 0 || index >= chartHistory.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: AppText(
                            DateFormat.Md(
                              locale,
                            ).format(chartHistory[index].performedAt),
                            style: TextStyle(fontSize: 9.sp),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = rodIndex == 0
                          ? 'exercise_volume'.tr
                          : 'muscle_volume'.tr;
                      return BarTooltipItem(
                        '$label\n${_formatNumber(rod.toY)} $volumeUnit',
                        TextStyle(
                          color: context.theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                barGroups: [
                  for (var index = 0; index < chartHistory.length; index++)
                    BarChartGroupData(
                      x: index,
                      barsSpace: 2.w,
                      barRods: [
                        BarChartRodData(
                          toY: sessionVolumes[index],
                          color: primary,
                          width: 8.w,
                          borderRadius: BorderRadius.zero,
                        ),
                        BarChartRodData(
                          toY: muscleVolumes[index],
                          color: secondary,
                          width: 8.w,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
}
