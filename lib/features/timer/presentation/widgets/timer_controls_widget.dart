import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/timer/cubit/timer_cubit.dart';
import 'package:lift_log/features/timer/cubit/timer_states.dart';
import 'package:lift_log/features/timer/presentation/widgets/timer_duration_fields_widget.dart';

class TimerControlsWidget extends StatelessWidget {
  const TimerControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerStates>(
      builder: (context, state) {
        final cubit = context.read<TimerCubit>();
        final canReset = state.hasStarted || state.duration > Duration.zero;
        final canStart =
            state.mode == TimerMode.countUp || state.duration > Duration.zero;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionLabel(context, 'timer_mode'),
            SizedBox(height: AppSpacing.sm),
            SegmentedButton<TimerMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: TimerMode.countUp,
                  icon: const Icon(Icons.trending_up_rounded),
                  label: AppText('count_up'.tr, fontWeight: FontWeight.w600),
                ),
                ButtonSegment(
                  value: TimerMode.countDown,
                  icon: const Icon(Icons.hourglass_bottom_rounded),
                  label: AppText('count_down'.tr, fontWeight: FontWeight.w600),
                ),
              ],
              selected: {state.mode},
              onSelectionChanged: state.isRunning
                  ? null
                  : (selection) => cubit.setMode(selection.first),
            ),
            SizedBox(height: AppSpacing.lg),
            if (state.mode == TimerMode.countDown && !state.isRunning) ...[
              TimerDurationFieldsWidget(
                initialDuration: state.duration,
                onDurationChanged: cubit.setCountdownDuration,
              ),
              SizedBox(height: AppSpacing.sm),
            ],
            Row(
              children: [
                Expanded(
                  flex: canReset ? 3 : 1,
                  child: AppButton(
                    title: state.isRunning ? 'stop'.tr : 'start'.tr,
                    icon: Icon(
                      state.isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    onPressed: canStart
                        ? () => state.isRunning
                              ? cubit.stopTimer()
                              : cubit.startTimer()
                        : null,
                  ),
                ),
                if (canReset) ...[
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: cubit.resetTimer,
                      icon: const Icon(Icons.refresh_rounded),
                      label: AppText('reset'.tr, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return AppText(
      label.tr,
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: context.appColors.subtitle,
    );
  }
}
