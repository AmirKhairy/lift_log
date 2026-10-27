import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/workout_history/presentation/widgets/workout_log_tile.dart';

class WorkoutSessionCard extends StatelessWidget {
  const WorkoutSessionCard({super.key, required this.session});

  final WorkoutSessionModel session;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final time = DateFormat.jm(locale).format(session.performedAt);
    final exerciseLabel = session.logs.length == 1
        ? 'exercise'.tr
        : 'exercises'.tr;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        leading: Container(
          width: 40.w,
          height: 40.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.fitness_center_rounded,
            size: 20.sp,
            color: context.colors.primary,
          ),
        ),
        title: AppText(time),
        subtitle: AppText('${session.logs.length} $exerciseLabel'),
        childrenPadding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        children: [
          if (session.notes?.isNotEmpty == true)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: AppSpacing.sm),
              padding: EdgeInsets.all(AppSpacing.nm),
              decoration: BoxDecoration(
                color: context.appColors.border.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: AppText('${'notes'.tr}: ${session.notes!}'),
            ),
          for (final log in session.logs) WorkoutLogTile(log: log),
        ],
      ),
    );
  }
}
