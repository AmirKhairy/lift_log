import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/timer/cubit/timer_cubit.dart';
import 'package:lift_log/features/timer/cubit/timer_states.dart';

class TimerDisplayWidget extends StatelessWidget {
  const TimerDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerStates>(
      builder: (context, state) {
        final duration = state.duration;

        final progress = state.totalDuration > Duration.zero
            ? (duration.inMilliseconds / state.totalDuration.inMilliseconds)
                  .clamp(0.0, 1.0)
            : 0.0;

        final hours = duration.inHours.toString().padLeft(2, '0');

        final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');

        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

        final statusKey = state is TimerCompleted
            ? 'completed'
            : state is TimerRunning
            ? (state.mode == TimerMode.countDown ? 'running' : 'counting_up')
            : 'ready';

        return Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Column(
              children: [
                AppText(
                  state.mode == TimerMode.countDown ? 'remaining' : 'elapsed',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: context.appColors.subtitle,
                ),
                SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: 238.w,
                  height: 238.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: state.mode == TimerMode.countDown
                              ? progress
                              : null,
                          strokeWidth: 12.w,
                          strokeCap: StrokeCap.round,
                          backgroundColor:
                              context.colors.surfaceContainerHighest,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            '$hours:$minutes:$seconds',
                            textAlign: TextAlign.center,
                            fontSize: 39.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colors.onSurface,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          AppText(
                            statusKey,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: state is TimerCompleted
                                ? context.appColors.success
                                : context.colors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (state.mode == TimerMode.countDown &&
                    state.totalDuration > Duration.zero) ...[
                  SizedBox(height: AppSpacing.md),
                  AppText(
                    '${'total_duration'.tr}: ${_formatDuration(state.totalDuration)}',
                    fontSize: 13.sp,
                    color: context.appColors.subtitle,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration value) {
    final hours = value.inHours.toString().padLeft(2, '0');
    final minutes = (value.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
