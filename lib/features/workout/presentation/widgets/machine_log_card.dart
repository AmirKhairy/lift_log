import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';
import 'package:lift_log/features/workout/presentation/widgets/set_row.dart';

class MachineLogCard extends StatefulWidget {
  const MachineLogCard({
    super.key,
    required this.machineIndex,
    required this.canRemove,
    required this.onRemove,
  });

  final int machineIndex;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  State<MachineLogCard> createState() => _MachineLogCardState();
}

class _MachineLogCardState extends State<MachineLogCard> {
  late final TextEditingController _notesController;

  WorkoutMachineDraft get _log =>
      context.read<WorkoutCubit>().draft.machines[widget.machineIndex];

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: _log.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final log = _log;
    final cubit = context.read<WorkoutCubit>();

    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText(log.machine.name ?? '', fontSize: 17.sp),
                ),
                if (widget.canRemove)
                  IconButton(
                    tooltip: 'remove_machine'.tr,
                    onPressed: widget.onRemove,
                    icon: Icon(
                      Icons.delete_outline,
                      color: context.theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                AppText('set'.tr),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: AppText('weight'.tr)),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: AppText('reps'.tr)),
                const SizedBox(width: 48),
              ],
            ),
            for (var setIndex = 0; setIndex < log.sets.length; setIndex++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: SetRow(
                  key: ValueKey('${widget.machineIndex}-$setIndex'),
                  machineIndex: widget.machineIndex,
                  setIndex: setIndex,
                ),
              ),
            SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: _notesController,
              hint: 'machine_workout_notes_hint',
              onChanged: (value) =>
                  cubit.updateMachineNotes(widget.machineIndex, value),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => cubit.addSet(widget.machineIndex),
                icon: const Icon(Icons.add),
                label: AppText('add_set'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
