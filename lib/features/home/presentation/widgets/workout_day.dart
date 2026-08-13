import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';


class WorkoutDay extends StatelessWidget {
  const WorkoutDay({
    super.key,
    required this.day,
    required this.color,
    this.isToday = false,
  });

  final DateTime day;
  final Color color;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(color: context.theme.colorScheme.onPrimary, width: 2.w)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: context.theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
