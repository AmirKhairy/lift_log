import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_labeled_text_field.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';
import 'package:lift_log/features/timer/cubit/timer_cubit.dart';
import 'package:lift_log/features/timer/cubit/timer_states.dart';

class TimerControlsWidget extends StatelessWidget {
  const TimerControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerStates>(
      builder: (context, state) {
        final cubit = context.read<TimerCubit>();

        return Column(
          children: [
            SegmentedButton<TimerMode>(
              segments: [
                ButtonSegment(
                  value: TimerMode.countUp,
                  icon: Icon(
                    Icons.timer_outlined,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  label: AppText(
                    'count_up'.tr,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
                ButtonSegment(
                  value: TimerMode.countDown,
                  icon: Icon(
                    Icons.timer,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  label: AppText(
                    'count_down'.tr,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
              ],
              selected: {state.mode},
              onSelectionChanged: state.isRunning
                  ? null
                  : (selection) {
                      cubit.setMode(selection.first);
                    },
            ),

            SizedBox(height: AppSpacing.lg),

            if (state.mode == TimerMode.countDown && !state.isRunning) ...[
              AppButton(
                title: state.duration > Duration.zero
                    ? 'change_time'.tr
                    : 'set_time'.tr,
                onPressed: () {
                  final timerCubit = context.read<TimerCubit>();
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    backgroundColor: context.theme.scaffoldBackgroundColor,
                    builder: (context) {
                      return BlocProvider.value(
                        value: timerCubit,
                        child: _TimerDurationSheet(
                          initialDuration: state.duration,
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: AppSpacing.sm),
            ],

            Row(
              children: [
                Expanded(
                  child: AppButton(
                    title: state.isRunning ? 'stop'.tr : 'start'.tr,
                    textColor: context.theme.colorScheme.onSurface,
                    onPressed:
                        state.mode == TimerMode.countDown &&
                            state.duration <= Duration.zero
                        ? null
                        : () {
                            if (state.isRunning) {
                              cubit.stopTimer();
                            } else {
                              cubit.startTimer();
                            }
                          },
                  ),
                ),
                if (state.hasStarted || state.duration > Duration.zero) ...[
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      title: 'reset'.tr,
                      textColor: context.theme.colorScheme.onError,
                      backgroundColor: context.theme.colorScheme.errorContainer,
                      onPressed: () {
                        cubit.resetTimer();
                      },
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
}

class _TimerDurationSheet extends StatefulWidget {
  const _TimerDurationSheet({required this.initialDuration});

  final Duration initialDuration;

  @override
  State<_TimerDurationSheet> createState() => _TimerDurationSheetState();
}

class _TimerDurationSheetState extends State<_TimerDurationSheet> {
  late final TextEditingController _hoursController;
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();

    _hoursController = TextEditingController(
      text: widget.initialDuration.inHours.toString().padLeft(2, '0'),
    );

    _minutesController = TextEditingController(
      text: (widget.initialDuration.inMinutes % 60).toString().padLeft(2, '0'),
    );

    _secondsController = TextEditingController(
      text: (widget.initialDuration.inSeconds % 60).toString().padLeft(2, '0'),
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              'set_countdown'.tr,
              textAlign: TextAlign.center,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.onSurface,
            ),

            SizedBox(height: AppSpacing.lg),

            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    label: 'hours'.tr,
                    child: AppTextField(
                      controller: _hoursController,
                      keyboardType: TextInputType.number,
                      hint: '00',
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: LabeledTextField(
                    label: 'minutes'.tr,
                    child: AppTextField(
                      controller: _minutesController,
                      keyboardType: TextInputType.number,
                      hint: '00',
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: LabeledTextField(
                    label: 'seconds'.tr,
                    child: AppTextField(
                      controller: _secondsController,
                      keyboardType: TextInputType.number,
                      hint: '00',
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.lg),

            AppText(
              'quick_select'.tr,
              textAlign: TextAlign.center,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: context.appColors.subtitle,
            ),

            SizedBox(height: AppSpacing.sm),

            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                ActionChip(
                  label: AppText(
                    '30 ${'sec'.tr}',
                    color: context.theme.colorScheme.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () {
                    _secondsController.text = '30';
                    _minutesController.text = '00';
                    _hoursController.text = '00';
                  },
                ),
                ActionChip(
                  label: AppText(
                    '1 ${'min'.tr}',
                    color: context.theme.colorScheme.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () {
                    _secondsController.text = '00';
                    _minutesController.text = '01';
                    _hoursController.text = '00';
                  },
                ),
                ActionChip(
                  label: AppText(
                    '5 ${'min'.tr}',
                    color: context.theme.colorScheme.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () {
                    _secondsController.text = '00';
                    _minutesController.text = '05';
                    _hoursController.text = '00';
                  },
                ),
                ActionChip(
                  label: AppText(
                    '10 ${'min'.tr}',
                    color: context.theme.colorScheme.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () {
                    _secondsController.text = '00';
                    _minutesController.text = '10';
                    _hoursController.text = '00';
                  },
                ),
                ActionChip(
                  label: AppText(
                    '30 ${'min'.tr}',
                    color: context.theme.colorScheme.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () {
                    _secondsController.text = '00';
                    _minutesController.text = '30';
                    _hoursController.text = '00';
                  },
                ),
              ],
            ),

            SizedBox(height: AppSpacing.lg),

            AppButton(
              title: 'set_timer'.tr,
              onPressed: () {
                final hours = int.tryParse(_hoursController.text) ?? 0;

                final minutes = int.tryParse(_minutesController.text) ?? 0;

                final seconds = int.tryParse(_secondsController.text) ?? 0;

                final duration = Duration(
                  hours: hours,
                  minutes: minutes,
                  seconds: seconds,
                );

                if (duration <= Duration.zero) {
                  return;
                }

                context.read<TimerCubit>().setCountdownDuration(duration);

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
