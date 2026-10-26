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
    this.showAll = false,
    this.isAllSelected = false,
    this.onAllSelected,
  });

  final MuscleGroup? selectedMuscleGroup;
  final ValueChanged<MuscleGroup> onSelected;
  final bool showAll;
  final bool isAllSelected;
  final VoidCallback? onAllSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: MuscleGroup.values.length + (showAll ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isAll = showAll && index == 0;
          final muscleGroup = isAll
              ? null
              : MuscleGroup.values[index - (showAll ? 1 : 0)];
          final isSelected = isAll
              ? isAllSelected
              : muscleGroup == selectedMuscleGroup;

          return ChoiceChip(
            label: AppText(
              isAll ? 'all' : muscleGroup!.displayName,
              color: isSelected
                  ? context.theme.colorScheme.onPrimary
                  : context.theme.colorScheme.onSurface,
              fontSize: 13.sp,
            ),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) {
              if (isAll) {
                onAllSelected?.call();
              } else {
                onSelected(muscleGroup!);
              }
            },
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
        },
      ),
    );
  }
}
