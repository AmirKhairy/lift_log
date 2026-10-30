import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/utils/target_muscle.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/muscle_group_selector.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/target_muscle_selector.dart';
import 'package:lift_log/features/machines/cubit/machines_cubit.dart';
import 'package:lift_log/features/machines/cubit/machines_state.dart';
import 'package:lift_log/features/machines/presentation/widgets/machines_empty_view.dart';
import 'package:lift_log/features/machines/presentation/widgets/machines_list.dart';

class MachinesPage extends StatelessWidget {
  const MachinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppPadding.horizontal,
          child: AppText(
            'your_machines'.tr,
            color: context.theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: AppSpacing.nm),
        Expanded(
          child: BlocBuilder<MachinesCubit, MachinesState>(
            builder: (context, state) {
              final hasNoMachines =
                  state is MachinesLoadedSuccess && state.machines.isEmpty;

              if (hasNoMachines) {
                return const MachinesEmptyView(hasAnyMachines: false);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: AppPadding.horizontal,
                    child: MuscleGroupSelector(
                      selectedMuscleGroup: state.selectedMuscleGroup,
                      showAll: true,
                      isAllSelected: state.selectedMuscleGroup == null,
                      onSelected: context
                          .read<MachinesCubit>()
                          .selectMuscleGroup,
                      onAllSelected: context
                          .read<MachinesCubit>()
                          .selectAllMuscleGroups,
                    ),
                  ),
                  if (state.selectedMuscleGroup != null) ...[
                    SizedBox(height: AppSpacing.sm),
                    TargetMuscleSelector(
                      options: targetMusclesFor(state.selectedMuscleGroup!),
                      selected: state.selectedTargetMuscle,
                      showAll: true,
                      onSelected: context
                          .read<MachinesCubit>()
                          .selectTargetMuscle,
                      onAllSelected: () => context
                          .read<MachinesCubit>()
                          .selectTargetMuscle(null),
                    ),
                  ],
                  SizedBox(height: AppSpacing.nm),
                  Expanded(child: MachinesList(state: state)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
