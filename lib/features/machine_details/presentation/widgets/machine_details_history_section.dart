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
      return HistoryMessageCard(
        icon: Icons.cloud_off_rounded,
        message: 'workout_history_error',
        color: context.theme.colorScheme.error,
      );
    }
    if (history.isEmpty) {
      return HistoryMessageCard(
        icon: Icons.history_rounded,
        message: 'no_machine_history',
        color: context.theme.colorScheme.primary,
      );
    }

    final setCount = history.fold<int>(
      0,
      (total, session) => total + session.sets.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HistorySummary(sessionCount: history.length, setCount: setCount),
        SizedBox(height: AppSpacing.md.h),
        for (var index = 0; index < history.length; index++) ...[
          if (index > 0) SizedBox(height: AppSpacing.sm.h),
          MachineHistoryTile(item: history[index]),
        ],
      ],
    );
  }
}

class HistorySummary extends StatelessWidget {
  const HistorySummary({
    super.key,
    required this.sessionCount,
    required this.setCount,
  });

  final int sessionCount;
  final int setCount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: HistorySummaryItem(
              icon: Icons.calendar_month_rounded,
              value: sessionCount.toString(),
              label: 'history_sessions',
            ),
          ),
          Container(width: 1, height: 34.h, color: context.appColors.border),
          Expanded(
            child: HistorySummaryItem(
              icon: Icons.fitness_center_rounded,
              value: setCount.toString(),
              label: 'history_sets',
            ),
          ),
        ],
      ),
    );
  }
}

class HistorySummaryItem extends StatelessWidget {
  const HistorySummaryItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20.sp, color: context.theme.colorScheme.primary),
        SizedBox(width: AppSpacing.sm.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(value, fontSize: 16.sp, fontWeight: FontWeight.w800),
            AppText(
              label,
              color: context.appColors.subtitle,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }
}

class HistoryMessageCard extends StatelessWidget {
  const HistoryMessageCard({
    super.key,
    required this.icon,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: AppText(
              message,
              color: context.appColors.subtitle,
              fontSize: 13.sp,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class MachineHistoryTile extends StatelessWidget {
  const MachineHistoryTile({super.key, required this.item});

  final MachineWorkoutHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat('EEEE, MMMM d, y', locale).format(item.performedAt);
    final time = DateFormat.jm(locale).format(item.performedAt);

    return AppCard(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md.w,
        AppSpacing.md.h,
        AppSpacing.md.w,
        AppSpacing.sm.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                ),
                child: Icon(
                  Icons.event_available_rounded,
                  color: context.theme.colorScheme.primary,
                  size: 21.sp,
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      '$date, $time',
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    AppText(
                      '${item.sets.length} ${'history_sets'.tr}',
                      color: context.appColors.subtitle,
                      fontSize: 12.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (item.logNotes?.trim().isNotEmpty == true) ...[
            SizedBox(height: AppSpacing.md.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.sm.w),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(AppSpacing.sm.r),
              ),
              child: AppText(
                item.logNotes!.trim(),
                color: context.appColors.subtitle,
                fontSize: 12.sp,
                maxLines: 4,
              ),
            ),
          ],
          SizedBox(height: AppSpacing.md.h),
          SetTableHeader(),
          SizedBox(height: AppSpacing.xs.h),
          for (final set in item.sets) HistorySetRow(set: set),
        ],
      ),
    );
  }
}

class SetTableHeader extends StatelessWidget {
  const SetTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: context.appColors.subtitle,
      fontSize: 11.sp,
      fontWeight: FontWeight.w700,
    );
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.xs.r),
      ),
      child: Row(
        children: [
          Expanded(child: AppText('set', style: style)),
          Expanded(child: AppText('weight', style: style)),
          Expanded(child: AppText('rep', style: style)),
        ],
      ),
    );
  }
}

class HistorySetRow extends StatelessWidget {
  const HistorySetRow({super.key, required this.set});

  final WorkoutSetModel set;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      child: Row(
        children: [
          Expanded(child: AppText(set.setNumber.toString(), fontSize: 13.sp)),
          Expanded(child: AppText(_formatNumber(set.weight), fontSize: 13.sp)),
          Expanded(child: AppText(set.reps.toString(), fontSize: 13.sp)),
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
