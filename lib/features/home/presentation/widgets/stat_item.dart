import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class StatItem extends StatelessWidget {
  const StatItem({
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
      children: [
        Icon(icon, color: context.theme.colorScheme.onPrimary, size: 28.sp),

        SizedBox(width: AppSpacing.sm),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                value,
                color: context.theme.colorScheme.onPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: AppSpacing.xs),
              AppText(
                label,
                color: context.theme.colorScheme.onPrimary.withValues(
                  alpha: 0.7,
                ),
                fontSize: 12.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
