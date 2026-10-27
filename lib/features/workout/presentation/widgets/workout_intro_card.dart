import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class WorkoutIntroCard extends StatelessWidget {
  const WorkoutIntroCard({super.key, required this.machineOnly});

  final bool machineOnly;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.primary,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26.r,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              child: Icon(
                machineOnly ? Icons.add_chart_rounded : Icons.bolt_rounded,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'workout',
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  AppText(
                    machineOnly ? 'log_this_machine' : 'workout_exercises',
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
