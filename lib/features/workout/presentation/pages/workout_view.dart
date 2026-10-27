import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/models/machine_image.dart';
import 'package:lift_log/core/models/machine_model.dart';
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
import 'package:lift_log/features/workout/presentation/widgets/workout_intro_card.dart';
import 'package:lift_log/features/workout/presentation/widgets/workout_notes_field.dart';

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
              WorkoutIntroCard(machineOnly: machineOnly),
              SizedBox(height: AppSpacing.md),
              PerformedAtCard(
                performedAt: draft.performedAt,
                enabled: !saving,
                onChanged: cubit.updatePerformedDateTime,
              ),
              SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText(
                    'workout_exercises',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  if (!machineOnly)
                    TextButton.icon(
                      onPressed: saving || cubit.isLoadingMachines
                          ? null
                          : () => _selectMachine(context, cubit),
                      icon: const Icon(Icons.add_rounded),
                      label: AppText('add_machine'),
                    ),
                ],
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
                  canRemove: !machineOnly,
                  onRemove: () => cubit.removeMachine(machineIndex),
                ),
              if (error != null)
                Padding(
                  padding: EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    error.tr,
                    style: TextStyle(color: context.colors.error),
                  ),
                ),
              if (!machineOnly) ...[
                SizedBox(height: AppSpacing.sm),
                WorkoutNotesField(onChanged: cubit.updateNotes),
              ],
              SizedBox(height: AppSpacing.lg),
              AppButton(
                title: 'save_workout',
                loading: saving,
                onPressed: cubit.save,
                icon: const Icon(Icons.check_rounded),
              ),
              SizedBox(height: AppSpacing.sm),
            ],
          );
        },
      ),
    );
  }

  Future<void> _selectMachine(BuildContext context, WorkoutCubit cubit) async {
    final available = cubit.selectableMachines;
    if (available.isEmpty) return;

    final machine = await showModalBottomSheet<MachineModel>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          children: [
            for (final item in available)
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                leading: MachineImage(
                  imageUrl: item.imageUrl,
                  width: 60.w,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  fit: BoxFit.contain,
                ),
                title: AppText(item.name ?? '', fontSize: 17.sp),
                subtitle: AppText(item.muscleGroup?.displayName ?? ''),
                onTap: () => Navigator.pop(context, item),
              ),
          ],
        ),
      ),
    );

    if (machine != null && context.mounted) cubit.addMachine(machine);
  }
}
