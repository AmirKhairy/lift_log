import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/workout_history/presentation/widgets/workout_session_card.dart';

class WorkoutDaySection extends StatelessWidget {
  const WorkoutDaySection({
    super.key,
    required this.date,
    required this.sessions,
  });

  final DateTime date;
  final List<WorkoutSessionModel> sessions;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateLabel = DateFormat('EEEE, MMMM d, y', locale).format(date);
    final workoutLabel = sessions.length == 1 ? 'workout'.tr : 'workouts'.tr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: context.colors.onPrimary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.nm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    dateLabel,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  AppText(
                    '${sessions.length} $workoutLabel',
                    fontWeight: FontWeight.w700,
                    color: context.appColors.subtitle,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.nm),
        for (var index = 0; index < sessions.length; index++) ...[
          WorkoutSessionCard(session: sessions[index]),
          if (index != sessions.length - 1) SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
