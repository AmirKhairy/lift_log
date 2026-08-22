import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class MuscleGroupSelector extends StatelessWidget {
  const MuscleGroupSelector({
    super.key,
    required this.selectedMuscleGroup,
    required this.onSelected,
  });

  final MuscleGroup? selectedMuscleGroup;
  final ValueChanged<MuscleGroup> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: MuscleGroup.values.map((muscleGroup) {
        final isSelected = muscleGroup == selectedMuscleGroup;

        return ChoiceChip(
          label: AppText(
            muscleGroup.displayName,
            color: isSelected
                ? context.theme.colorScheme.onPrimary
                : context.theme.colorScheme.onSurface,
            fontSize: 13.sp,
          ),
          selected: isSelected,
          showCheckmark: false,
          onSelected: (_) => onSelected(muscleGroup),
          selectedColor: context.theme.colorScheme.primary,
          backgroundColor: context.theme.colorScheme.surface,
          side: BorderSide(
            color: isSelected
                ? context.theme.colorScheme.primary
                : context.appColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        );
      }).toList(),
    );
  }
}
