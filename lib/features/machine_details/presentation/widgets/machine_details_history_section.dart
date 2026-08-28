import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class MachineDetailsHistorySection extends StatelessWidget {
  const MachineDetailsHistorySection({
    super.key,
    required this.history,
    this.error,
  });

  final List<MachineWorkoutHistoryItem> history;
  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return AppText(
        'workout_history_error',
        color: context.appColors.subtitle,
        fontSize: 14.sp,
      );
    }

    if (history.isEmpty) {
      return AppText(
        'no_machine_history',
        color: context.appColors.subtitle,
        fontSize: 14.sp,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < history.length; index++) ...[
          if (index > 0) SizedBox(height: AppSpacing.sm),
          MachineHistoryTile(item: history[index]),
        ],
      ],
    );
  }
}

class MachineHistoryTile extends StatelessWidget {
  const MachineHistoryTile({super.key, required this.item});

  final MachineWorkoutHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMMd().add_jm().format(item.performedAt);

    return AppCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(date, fontWeight: FontWeight.w600, fontSize: 14.sp),
          if (item.logNotes?.isNotEmpty == true) ...[
            SizedBox(height: AppSpacing.xs),
            AppText(
              item.logNotes!,
              color: context.appColors.subtitle,
              fontSize: 13.sp,
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          for (final set in item.sets)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: AppText(
                '${'set'.tr} ${set.setNumber}: ${_formatNumber(set.weight)} ${'weight'.tr} * ${set.reps} ${'rep'.tr}',
                fontSize: 13.sp,
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
