import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class PerformanceTipCard extends StatelessWidget {
  const PerformanceTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.nm),
        border: Border.all(color: context.appColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: context.theme.colorScheme.primary,
              size: 22.sp,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'performance_tip',
                  color: context.theme.colorScheme.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: AppSpacing.xs),
                AppText(
                  'add_machine_tip',
                  color: context.theme.colorScheme.onSurface,
                  fontSize: 12.sp,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
