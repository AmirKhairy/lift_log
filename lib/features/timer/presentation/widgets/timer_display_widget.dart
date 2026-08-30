import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
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

        double progress = 0;

        if (state.mode == TimerMode.countDown) {
          final total = context.read<TimerCubit>().countdownDuration;

          if (total > Duration.zero) {
            progress = (duration.inMilliseconds / total.inMilliseconds).clamp(
              0.0,
              1.0,
            );
          }
        }

        final hours = duration.inHours.toString().padLeft(2, '0');

        final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');

        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 270.w,
              height: 270.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 270.w,
                    height: 270.h,
                    child: CircularProgressIndicator(
                      value: state.mode == TimerMode.countDown
                          ? progress
                          : null,
                      strokeWidth: 10.w,
                      backgroundColor:
                          context.theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        state.mode == TimerMode.countDown
                            ? 'remaining'.tr
                            : 'elapsed'.tr,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppText(
                        '$hours:$minutes:$seconds',
                        textAlign: TextAlign.center,
                        fontSize: 42.sp,
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onSurface,
                      ),
                      if (state is TimerRunning) ...[
                        SizedBox(height: AppSpacing.sm),
                        AppText(
                          (state.mode == TimerMode.countDown
                                  ? 'running'
                                  : 'counting_up')
                              .tr,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.primary,
                        ),
                      ],
                      if (state is TimerCompleted) ...[
                        SizedBox(height: AppSpacing.sm),
                        AppText(
                          'completed'.tr,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
