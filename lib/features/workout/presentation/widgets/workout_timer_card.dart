import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class WorkoutTimerCard extends StatelessWidget {
  const WorkoutTimerCard({
    super.key,
    required this.started,
    required this.paused,
    required this.finished,
    required this.hasExercises,
    required this.elapsed,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onFinish,
    required this.onReset,
    required this.onContinue,
  });

  final bool started;
  final bool paused;
  final bool finished;
  final bool hasExercises;
  final Duration elapsed;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onFinish;
  final VoidCallback onReset;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined, color: context.colors.primary),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppText('workout_timer', fontWeight: FontWeight.w700),
                ),
                Text(
                  '$hours:$minutes:$seconds',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            if (!started)
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: AppButton(
                  title: 'start_workout',
                  onPressed: hasExercises ? onStart : null,
                  icon: const Icon(Icons.play_arrow_rounded),
                ),
              )
            else if (!finished)
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        title: paused ? 'resume_workout' : 'pause_workout',
                        onPressed: paused ? onResume : onPause,
                        icon: Icon(
                          paused
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppButton(
                        title: 'finish_workout',
                        onPressed: onFinish,
                        icon: const Icon(Icons.stop_rounded),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText('workout_finished', color: context.colors.primary),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: onReset,
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: AppText('reset_workout_timer'),
                      ),
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
