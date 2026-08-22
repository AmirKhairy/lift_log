import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class ImageSourceTile extends StatelessWidget {
  const ImageSourceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.5,
      ),
      borderRadius: BorderRadius.circular(AppSpacing.nm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.nm),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Icon(icon, color: context.theme.colorScheme.primary, size: 24.sp),
              SizedBox(width: AppSpacing.md),
              AppText(
                title,
                color: context.theme.colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: context.appColors.subtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
