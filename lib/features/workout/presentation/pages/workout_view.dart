import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/models/machine_image.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';
import 'package:lift_log/features/workout/cubit/workout_state.dart';
import 'package:lift_log/features/workout/presentation/widgets/machine_log_card.dart';
import 'package:lift_log/features/workout/presentation/widgets/performed_at_card.dart';
import 'package:lift_log/features/workout/presentation/widgets/routine_actions.dart';
import 'package:lift_log/features/workout/presentation/widgets/routine_delete_dialog.dart';
import 'package:lift_log/features/workout/presentation/widgets/routine_name_dialog.dart';
import 'package:lift_log/features/workout/presentation/widgets/workout_notes_field.dart';
import 'package:lift_log/features/workout/presentation/widgets/workout_timer_card.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({super.key, required this.machineOnly});

  final bool machineOnly;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: AppText('workout'.tr)),
      body: BlocConsumer<WorkoutCubit, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutSaved) {
            AppSnackbar.success(message: 'workout_saved'.tr, context: context);
            context.pop(true);
          }
        },
        builder: (context, state) {
          final cubit = context.read<WorkoutCubit>();
          final draft = cubit.draft;
          final saving = state is WorkoutSaving;
          final error = state is WorkoutEditing ? state.error : null;

          return ListView(
            children: [
              PerformedAtCard(
                performedAt: draft.performedAt,
                enabled: !saving && !cubit.isWorkoutStarted,
                onChanged: cubit.updatePerformedDateTime,
              ),
              SizedBox(height: AppSpacing.sm),
              WorkoutTimerCard(
                started: cubit.isWorkoutStarted,
                paused: cubit.isPaused,
                finished: cubit.isWorkoutFinished,
                hasExercises: draft.machines.isNotEmpty,
                elapsed: cubit.elapsed,
                onStart: cubit.startWorkout,
                onPause: cubit.pauseWorkout,
                onResume: cubit.resumeWorkout,
                onReset: cubit.resetWorkoutTimer,
                onContinue: cubit.continueWorkout,
                onFinish: () {
                  cubit.finishWorkout();
                },
              ),
              SizedBox(height: AppSpacing.lg),
              if (cubit.routines.isNotEmpty)
                RoutineActions(
                  routines: cubit.routines,
                  enabled: !saving,
                  onSelect: () => _selectRoutine(context, cubit),
                  onSave: () => _saveRoutine(context, cubit),
                  showSave: false,
                ),
              SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppText(
                      'workout_exercises',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: saving || cubit.isLoadingMachines
                        ? null
                        : () => _selectMachine(context, cubit),
                    icon: const Icon(Icons.add_rounded),
                    label: AppText('add_machine'),
                  ),
                ],
              ),
              if (draft.machines.isNotEmpty)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: saving ? null : cubit.clearMachines,
                    icon: const Icon(Icons.clear_all_rounded),
                    label: AppText('clear_exercises'),
                  ),
                ),
              SizedBox(height: AppSpacing.sm),

              if (draft.machines.isEmpty)
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        Icon(
                          Icons.fitness_center_rounded,
                          size: 36.sp,
                          color: context.colors.primary,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        AppText(
                          'workout_empty_machines',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              for (
                var machineIndex = 0;
                machineIndex < draft.machines.length;
                machineIndex++
              )
                MachineLogCard(
                  key: ValueKey(draft.machines[machineIndex].machine.id),
                  machineIndex: machineIndex,
                  canRemove: true,
                  onRemove: () => cubit.removeMachine(machineIndex),
                ),
              if (draft.machines.isNotEmpty)
                RoutineActions(
                  routines: cubit.routines,
                  enabled: !saving,
                  onSelect: () => _selectRoutine(context, cubit),
                  onSave: () => _saveRoutine(context, cubit),
                  showSelect: false,
                  showSave: cubit.shouldShowRoutineSave,
                  saveLabel: cubit.isEditingRoutine
                      ? 'update_routine'
                      : 'save_routine',
                ),
              if (error != null)
                Padding(
                  padding: EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    error.tr,
                    style: TextStyle(color: context.colors.error),
                  ),
                ),
              SizedBox(height: AppSpacing.sm),
              WorkoutNotesField(onChanged: cubit.updateNotes),
              SizedBox(height: AppSpacing.lg),
              AppButton(
                title: 'save_workout',
                loading: saving,
                onPressed: cubit.isWorkoutFinished ? cubit.save : null,
                icon: const Icon(Icons.check_rounded),
              ),
              SizedBox(height: AppSpacing.sm),
            ],
          );
        },
      ),
    );
  }

  Future<void> _selectRoutine(BuildContext context, WorkoutCubit cubit) async {
    final routine = await showModalBottomSheet<RoutineModel>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: cubit.routines.isEmpty
              ? [
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: AppText('no_routines', textAlign: TextAlign.center),
                  ),
                ]
              : [
                  for (final routine in cubit.routines)
                    ListTile(
                      leading: const Icon(Icons.playlist_play_rounded),
                      title: AppText(routine.name),
                      subtitle: AppText(
                        '${routine.exercises.length} ${'exercises'.tr}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'edit_routine'.tr,
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () {
                              Navigator.pop(sheetContext);
                              cubit.applyRoutine(routine, editing: true);
                              AppSnackbar.info(
                                message: 'routine_loaded_for_editing',
                                context: context,
                              );
                            },
                          ),
                          IconButton(
                            tooltip: 'delete_routine'.tr,
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: Theme.of(sheetContext).colorScheme.error,
                            ),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (_) => RoutineDeleteDialog(
                                  routineName: routine.name,
                                ),
                              );
                              if (confirmed != true || !context.mounted) {
                                return;
                              }
                              Navigator.pop(sheetContext);
                              try {
                                await cubit.deleteRoutine(routine.id);
                                if (context.mounted) {
                                  AppSnackbar.success(
                                    message: 'routine_deleted'.tr,
                                    context: context,
                                  );
                                }
                              } catch (error) {
                                if (context.mounted) {
                                  AppSnackbar.error(
                                    message: error.toString(),
                                    context: context,
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () => Navigator.pop(sheetContext, routine),
                    ),
                ],
        ),
      ),
    );
    if (routine != null && context.mounted) cubit.applyRoutine(routine);
  }

  Future<void> _saveRoutine(BuildContext context, WorkoutCubit cubit) async {
    final updating = cubit.appliedRoutineName != null;
    final name = await showDialog<String>(
      context: context,
      builder: (_) => RoutineNameDialog(initialName: cubit.appliedRoutineName),
    );
    if (name == null || !context.mounted) return;
    try {
      final saved = await cubit.saveRoutine(name);
      if (saved && context.mounted) {
        AppSnackbar.success(
          message: updating ? 'routine_updated' : 'routine_saved',
          context: context,
        );
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.error(message: error.toString(), context: context);
      }
    }
  }

  Future<void> _selectMachine(BuildContext context, WorkoutCubit cubit) async {
    final available = cubit.selectableMachines;

    final result = await showModalBottomSheet<Object?>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          children: [
            available.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        AppText(
                          'no_machines_available'.tr,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppButton(
                          title: 'add_machine'.tr,
                          icon: const Icon(Icons.add_rounded),
                          onPressed: () => Navigator.pop(sheetContext, true),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            for (final item in available)
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                leading: MachineImage(
                  imageUrl: item.imageUrl,
                  targetMuscle: item.targetMuscle,
                  width: 60.w,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  fit: BoxFit.contain,
                ),
                title: AppText("${item.name}", fontSize: 17.sp),
                subtitle: AppText(
                  "${item.muscleGroup?.displayName}: ${item.targetMuscle?.name.tr}",
                ),
                onTap: () => Navigator.pop(sheetContext, item),
              ),
          ],
        ),
      ),
    );

    if (result is MachineModel && context.mounted) {
      cubit.addMachine(result);
      return;
    }

    if (result == true && context.mounted) {
      final machine = await context.push<MachineModel>(AppRoutes.addMachine);
      if (machine != null && context.mounted) cubit.addMachine(machine);
    }
  }
}
