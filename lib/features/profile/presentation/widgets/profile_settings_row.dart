import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class ProfileSettingsRow extends StatelessWidget {
  const ProfileSettingsRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                label,
                fontSize: 14.sp,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
            AppText(value, fontSize: 14.sp, color: context.appColors.subtitle),
            SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              color: context.appColors.subtitle,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
