import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class BodyProgressSectionCard extends StatelessWidget {
  const BodyProgressSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.goalAchieved,
  });
  final String title;
  final Widget child;
  final bool? goalAchieved;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(title, fontWeight: FontWeight.bold, fontSize: 17.sp),
            if (goalAchieved != null && goalAchieved == true)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: AppText(
                  'goal_achieved',
                  color: AppColors.success,
                  fontSize: 12.sp,
                ),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        child,
      ],
    ),
  );
}
