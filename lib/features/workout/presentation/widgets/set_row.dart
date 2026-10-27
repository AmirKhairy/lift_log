import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';

class SetRow extends StatefulWidget {
  const SetRow({super.key, required this.machineIndex, required this.setIndex});

  final int machineIndex;
  final int setIndex;

  @override
  State<SetRow> createState() => _SetRowState();
}

class _SetRowState extends State<SetRow> {
  late final TextEditingController _weightController;
  late final TextEditingController _repsController;

  @override
  void initState() {
    super.initState();
    final set = _currentSet;
    _weightController = TextEditingController(
      text: set.weight?.toString() ?? '',
    );
    _repsController = TextEditingController(text: set.reps?.toString() ?? '');
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  WorkoutSetDraft get _currentSet => context
      .read<WorkoutCubit>()
      .draft
      .machines[widget.machineIndex]
      .sets[widget.setIndex];

  @override
  Widget build(BuildContext context) {
    final set = _currentSet;
    final cubit = context.read<WorkoutCubit>();

    return Row(
      children: [
        SizedBox(
          width: 28,
          child: AppText('${set.setNumber}', fontWeight: FontWeight.w700),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppTextField(
            controller: _weightController,
            hint: '0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                final isDecimal = RegExp(r'^\d*\.?\d*$').hasMatch(
                  newValue.text,
                );
                return isDecimal ? newValue : oldValue;
              }),
            ],
            onChanged: (value) => cubit.updateSet(
              machineIndex: widget.machineIndex,
              setIndex: widget.setIndex,
              weight: double.tryParse(value),
              reps: set.reps,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppTextField(
            controller: _repsController,
            hint: '0',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => cubit.updateSet(
              machineIndex: widget.machineIndex,
              setIndex: widget.setIndex,
              weight: set.weight,
              reps: int.tryParse(value),
            ),
          ),
        ),
        IconButton(
          tooltip: 'remove_set'.tr,
          onPressed: () =>
              cubit.removeSet(widget.machineIndex, widget.setIndex),
          icon: Icon(
            Icons.remove_circle_outline,
            color: context.theme.colorScheme.error,
          ),
        ),
      ],
    );
  }
}
