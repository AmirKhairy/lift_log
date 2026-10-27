import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/home/presentation/widgets/stat_item.dart';

class WorkoutOverviewSection extends StatelessWidget {
  const WorkoutOverviewSection({
    super.key,
    required this.workoutCount,
    required this.lastWorkoutDate,
    required this.onViewHistory,
  });

  final int workoutCount;
  final DateTime? lastWorkoutDate;
  final VoidCallback onViewHistory;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Container(
      margin: AppPadding.horizontal,
      padding: AppPadding.card,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            context.theme.colorScheme.primary,
            context.theme.colorScheme.primary.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.onPrimary.withValues(
                    alpha: 0.14,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.insights_rounded,
                    color: context.theme.colorScheme.onPrimary,
                    size: 22.sp,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppText(
                  'your_workout_summary'.tr,
                  color: context.theme.colorScheme.onPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

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
                      : DateFormat.yMd(locale).format(lastWorkoutDate!),
                  label: 'last_workout'.tr,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: onViewHistory,
              style: TextButton.styleFrom(
                foregroundColor: context.theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: AppText('workout_history'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
