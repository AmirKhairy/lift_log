import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              label,
              color: context.appColors.subtitle,
              fontSize: 14.sp,
            ),
          ),
          Expanded(
            flex: 3,
            child: AppText(
              value,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: context.theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
