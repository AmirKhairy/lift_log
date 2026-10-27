import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/machine_image.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class WorkoutLogTile extends StatelessWidget {
  const WorkoutLogTile({super.key, required this.log});

  final WorkoutLogModel log;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MachineImage(
                imageUrl: log.machine.imageUrl,
                width: 64.w,
                height: 64.w,
                borderRadius: BorderRadius.circular(14.r),
              ),
              SizedBox(width: AppSpacing.nm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      log.machine.name?.trim().isNotEmpty == true
                          ? log.machine.name!.trim()
                          : 'workout'.tr,
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                    ),
                    if (log.machine.muscleGroup != null) ...[
                      SizedBox(height: AppSpacing.xs),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: AppText(
                          log.machine.muscleGroup!.displayName,
                          fontWeight: FontWeight.w700,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: AppText(
                  '${log.sets.length} ${'sets'.tr}',
                  fontWeight: FontWeight.w700,
                  color: context.appColors.subtitle,
                ),
              ),
            ],
          ),
          if (log.notes?.isNotEmpty == true)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: AppSpacing.md),
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notes_rounded,
                    size: 16.sp,
                    color: context.appColors.subtitle,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppText(
                      '${'notes'.tr}: ${log.notes!}',
                      fontSize: 14.sp,
                      color: context.appColors.subtitle,
                    ),
                  ),
                ],
              ),
            ),
          if (log.sets.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            _buildSetTable(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSetTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.nm,
              vertical: AppSpacing.sm,
            ),
            color: context.theme.colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AppText(
                    'set'.tr,
                    color: context.appColors.subtitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AppText(
                    'weight'.tr,
                    color: context.appColors.subtitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AppText(
                    'reps'.tr,
                    color: context.appColors.subtitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          for (final set in log.sets) _buildSetRow(context, set),
        ],
      ),
    );
  }

  Widget _buildSetRow(BuildContext context, WorkoutSetModel set) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.nm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.appColors.border.withValues(alpha: 0.7),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 24.w,
              height: 24.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: AppText('${set.setNumber}', color: context.colors.primary),
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText(
              '${_formatNumber(set.weight)} ${'weight_unit'.tr}',
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText(
              '${set.reps} ${'rep'.tr}',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }
}
