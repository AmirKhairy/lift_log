import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/target_muscle.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class TargetMuscleSelector extends StatelessWidget {
  const TargetMuscleSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.showAll = false,
    this.onAllSelected,
  });

  final List<TargetMuscleOption> options;
  final TargetMuscle? selected;
  final ValueChanged<TargetMuscle> onSelected;
  final bool showAll;
  final VoidCallback? onAllSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: options.length + (showAll ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isAll = showAll && index == 0;
          final option = isAll ? null : options[index - (showAll ? 1 : 0)];
          final isSelected = isAll
              ? selected == null
              : option!.value == selected;

          return ChoiceChip(
            label: AppText(
              isAll ? 'all' : option!.displayName,
              color: isSelected
                  ? context.theme.colorScheme.onPrimary
                  : context.theme.colorScheme.onSurface,
              fontSize: 13.sp,
            ),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) =>
                isAll ? onAllSelected?.call() : onSelected(option!.value),
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
