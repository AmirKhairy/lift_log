import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/body_progress_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'body_progress_section_card.dart';

class BodyProgressPeriodChangesCard extends StatelessWidget {
  const BodyProgressPeriodChangesCard({super.key, required this.stats});
  final BodyProgressStats stats;
  @override
  Widget build(BuildContext context) => BodyProgressSectionCard(
    title: 'period_changes',
    child: Row(
      children: [
        Expanded(child: _metric(context, 'weekly', stats.weeklyChange)),
        Expanded(child: _metric(context, 'monthly', stats.monthlyChange)),
        Expanded(child: _metric(context, 'yearly', stats.yearlyChange)),
      ],
    ),
  );
  Widget _metric(BuildContext context, String label, double? value) => Column(
    children: [
      AppText(label, color: context.appColors.subtitle, fontSize: 12.sp),
      SizedBox(height: AppSpacing.xs),
      value == null
          ? AppText('-', fontWeight: FontWeight.bold)
          : AppText(
              '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}',
              fontWeight: FontWeight.bold,
            ),
    ],
  );
}
