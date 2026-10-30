import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class VolumeLegendItem extends StatelessWidget {
  const VolumeLegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.unit,
  });

  final Color color;
  final String label;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9.w,
          height: 9.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: AppSpacing.xs.w),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              label,
              color: context.appColors.subtitle,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
            Text(
              ' ($unit)',
              style: TextStyle(
                color: context.appColors.subtitle,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
