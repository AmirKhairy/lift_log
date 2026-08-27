import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/logic_utilities.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';
import 'package:lift_log/features/workout/cubit/workout_state.dart';
import 'package:lift_log/features/workout/presentation/widgets/machine_log_card.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key, this.initialMachine});

  final MachineModel? initialMachine;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          WorkoutCubit(initialMachine: initialMachine)..loadMachines(),
      child: const _WorkoutView(),
    );
  }
}

class _WorkoutView extends StatelessWidget {
  const _WorkoutView();

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
          final draft = context.read<WorkoutCubit>().draft;
          final saving = state is WorkoutSaving;
          final error = state is WorkoutEditing ? state.error : null;
          final workoutCubit = context.read<WorkoutCubit>();

          return ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: AppText('performed_at'.tr),
                subtitle: AppText(
                  LogicUtilities.instance.formatDateTime(
                    draft.performedAt,
                    context,
                  ),
                ),
                onTap: saving
                    ? null
                    : () async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          initialDate: draft.performedAt,
                        );
                        if (date == null || !context.mounted) return;

                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            draft.performedAt,
                          ),
                        );
                        if (time == null || !context.mounted) return;

                        workoutCubit.updatePerformedDateTime(date, time);
                      },
              ),

              SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText('workout_exercises'.tr, fontSize: 18.sp),
                  TextButton.icon(
                    onPressed: saving || workoutCubit.isLoadingMachines
                        ? null
                        : () async {
                            final available = workoutCubit.selectableMachines;
                            if (available.isEmpty) return;

                            final machine =
                                await showModalBottomSheet<MachineModel>(
                                  context: context,
                                  builder: (context) => SafeArea(
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        for (final item in available)
                                          ListTile(
                                            leading: const Icon(
                                              Icons.fitness_center,
                                            ),
                                            title: AppText(item.name ?? ''),
                                            subtitle: AppText(
                                              item.muscleGroup?.displayName ??
                                                  '',
                                            ),
                                            onTap: () =>
                                                Navigator.pop(context, item),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                            if (machine != null && context.mounted) {
                              workoutCubit.addMachine(machine);
                            }
                          },
                    icon: const Icon(Icons.add),
                    label: AppText('add_machine'.tr),
                  ),
                ],
              ),
              if (draft.machines.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(child: AppText('workout_empty_machines'.tr)),
                ),
              for (
                var machineIndex = 0;
                machineIndex < draft.machines.length;
                machineIndex++
              )
                MachineLogCard(
                  machineIndex: machineIndex,
                  onRemove: () =>
                      context.read<WorkoutCubit>().removeMachine(machineIndex),
                ),
              if (error != null)
                Padding(
                  padding: EdgeInsets.only(top: AppSpacing.sm),
                  child: AppText(error.tr),
                ),
              SizedBox(height: AppSpacing.md),

              AppTextField(
                hint: 'workout_notes_hint',
                maxLines: 3,
                onChanged: context.read<WorkoutCubit>().updateNotes,
              ),
              SizedBox(height: AppSpacing.md),
              AppButton(
                title: 'save_workout',
                loading: saving,
                onPressed: () => context.read<WorkoutCubit>().save(),
                icon: const Icon(Icons.check),
              ),
            ],
          );
        },
      ),
    );
  }
}
