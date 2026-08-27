import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
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
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            log.machine.name ?? 'machine',
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
          if (log.notes?.isNotEmpty == true)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: AppText(log.notes!),
            ),
          SizedBox(height: AppSpacing.xs),
          for (final set in log.sets)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: AppText(
                '${'set'.tr} ${set.setNumber}: ${_formatNumber(set.weight)} ${'weight'.tr} x ${set.reps} ${'reps'.tr}',
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
