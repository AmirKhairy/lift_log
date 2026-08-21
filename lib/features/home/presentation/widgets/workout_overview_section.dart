import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/utils/logic_utilities.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/home/presentation/widgets/stat_item.dart';

class WorkoutOverviewSection extends StatelessWidget {
  const WorkoutOverviewSection({
    super.key,
    required this.workoutCount,
    required this.lastWorkoutDate,
  });

  final int workoutCount;
  final DateTime? lastWorkoutDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPadding.horizontal,
      padding: AppPadding.xs,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'your_workout_summary'.tr,
            color: context.theme.colorScheme.onPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),

          SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: StatItem(
                  icon: Icons.fitness_center,
                  value: workoutCount.toString(),
                  label: 'workouts_this_month'.tr,
                  animateValue: true,
                ),
              ),

              Expanded(
                child: StatItem(
                  icon: Icons.calendar_today,
                  value: lastWorkoutDate == null
                      ? '-'
                      : LogicUtilities.instance.formatDate(lastWorkoutDate!),
                  label: 'last_workout'.tr,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
