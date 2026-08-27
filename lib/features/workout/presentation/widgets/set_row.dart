import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';

class SetRow extends StatelessWidget {
  const SetRow({super.key, required this.machineIndex, required this.setIndex});

  final int machineIndex;
  final int setIndex;

  @override
  Widget build(BuildContext context) {
    final set = context
        .read<WorkoutCubit>()
        .draft
        .machines[machineIndex]
        .sets[setIndex];
    final cubit = context.read<WorkoutCubit>();

    return Row(
      children: [
        Expanded(child: AppText('${set.setNumber}')),
        Expanded(
          child: AppTextField(
            hint: '0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),

            onChanged: (value) => cubit.updateSet(
              machineIndex: machineIndex,
              setIndex: setIndex,
              weight: double.tryParse(value),
              reps: set.reps,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppTextField(
            hint: '0',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => cubit.updateSet(
              machineIndex: machineIndex,
              setIndex: setIndex,
              weight: set.weight,
              reps: int.tryParse(value),
            ),
          ),
        ),
        IconButton(
          tooltip: 'remove_set'.tr,
          onPressed: () => cubit.removeSet(machineIndex, setIndex),
          icon: Icon(
            Icons.remove_circle_outline,
            color: context.theme.colorScheme.error,
          ),
        ),
      ],
    );
  }
}
