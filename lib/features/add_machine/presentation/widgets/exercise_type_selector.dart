import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/exercise_type_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class ExerciseTypeSelector extends StatelessWidget {
  const ExerciseTypeSelector({super.key, required this.selected, required this.onSelected});

  final ExerciseType selected;
  final ValueChanged<ExerciseType> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.sm,
    runSpacing: AppSpacing.sm,
    children: [for (final type in ExerciseType.values) ChoiceChip(
      label: AppText(type.localizationKey.tr, color: type == selected
          ? context.theme.colorScheme.onPrimary : context.theme.colorScheme.onSurface, fontSize: 13.sp),
      selected: type == selected,
      showCheckmark: false,
      onSelected: (_) => onSelected(type),
      selectedColor: context.theme.colorScheme.primary,
    )],
  );
}
