import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/timer/presentation/widgets/timer_controls_widget.dart';
import 'package:lift_log/features/timer/presentation/widgets/timer_display_widget.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: AppText(
          'workout_timer'.tr,
          fontSize: 26.sp,
          fontWeight: FontWeight.bold,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.lg),

            const AppStaggeredAnimation(index: 0, child: TimerDisplayWidget()),

            SizedBox(height: AppSpacing.lg),

            const AppStaggeredAnimation(index: 2, child: TimerControlsWidget()),
          ],
        ),
      ),
    );
  }
}
