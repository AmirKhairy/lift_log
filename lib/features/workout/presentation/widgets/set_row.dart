import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_enums.dart';
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
  late final TextEditingController _durationController;
  DurationUnit _durationUnit = DurationUnit.minutes;

  @override
  void initState() {
    super.initState();
    final set = _currentSet;
    _weightController = TextEditingController(
      text: set.weight?.toString() ?? '',
    );
    _repsController = TextEditingController(text: set.reps?.toString() ?? '');
    _durationController = TextEditingController(
      text: _durationDisplayValue(set.durationSeconds),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SetRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    final set = _currentSet;
    if (!FocusScope.of(context).hasFocus) {
      _weightController.text = set.weight?.toString() ?? '';
      _repsController.text = set.reps?.toString() ?? '';
      _durationController.text = _durationDisplayValue(set.durationSeconds);
    }
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

    final type = _currentMachine.exerciseType;
    return Row(
      children: [
        SizedBox(
          width: 28,
          child: AppText('${set.setNumber}', fontWeight: FontWeight.w700),
        ),
        SizedBox(width: AppSpacing.sm),
        if (type != ExerciseType.reps && type != ExerciseType.time)
          Expanded(
            child: AppTextField(
              controller: _weightController,
              hint: '0',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final isDecimal = RegExp(
                    r'^\d*\.?\d*$',
                  ).hasMatch(newValue.text);
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
        if (type == ExerciseType.weightReps) SizedBox(width: AppSpacing.sm),
        if (type != ExerciseType.time)
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
        if (type == ExerciseType.time)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    ChoiceChip(
                      label: AppText('minutes'.tr),
                      selected: _durationUnit == DurationUnit.minutes,
                      onSelected: (_) =>
                          _changeDurationUnit(DurationUnit.minutes),
                    ),
                    ChoiceChip(
                      label: AppText('seconds'.tr),
                      selected: _durationUnit == DurationUnit.seconds,
                      onSelected: (_) =>
                          _changeDurationUnit(DurationUnit.seconds),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                AppTextField(
                  controller: _durationController,
                  hint: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => cubit.updateSet(
                    machineIndex: widget.machineIndex,
                    setIndex: widget.setIndex,
                    durationSeconds: _durationToSeconds(value),
                  ),
                ),
              ],
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

  MachineModel get _currentMachine =>
      context.read<WorkoutCubit>().draft.machines[widget.machineIndex].machine;

  int? _durationToSeconds(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null) return null;
    return _durationUnit == DurationUnit.minutes ? parsed * 60 : parsed;
  }

  String _durationDisplayValue(int? seconds) {
    if (seconds == null) return '';
    if (_durationUnit == DurationUnit.minutes && seconds % 60 == 0) {
      return (seconds ~/ 60).toString();
    }
    return seconds.toString();
  }

  void _changeDurationUnit(DurationUnit unit) {
    if (_durationUnit == unit) return;
    final seconds = _durationToSeconds(_durationController.text);
    setState(() {
      _durationUnit = unit;
      _durationController.text = _durationDisplayValue(seconds);
      _durationController.selection = TextSelection.collapsed(
        offset: _durationController.text.length,
      );
    });
  }
}
