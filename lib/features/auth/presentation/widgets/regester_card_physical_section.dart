import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/helpers/validators.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/widgets/app_picker_field.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';

class RegesterCardPhysicalSection extends StatelessWidget {
  const RegesterCardPhysicalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppStaggeredAnimation(
          index: 5,
          child: Row(
            children: [
              Expanded(
                child: AppPickerField<int>(
                  label: 'age'.tr,
                  hint: 'select'.tr,
                  value: context.read<AuthCubit>().age,
                  fillColor: AppColors.gray,

                  validator: (value) => Validators.age(value),
                  onTap: () => context.read<AuthCubit>().openAgePicker(context),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: AppPickerField<Gender>(
                  label: 'gender'.tr,
                  hint: 'select'.tr,
                  value: context.read<AuthCubit>().gender,
                  fillColor: AppColors.gray,
                  displayText: (g) =>
                      g.name[0].toUpperCase() + g.name.substring(1),
                  validator: (value) => Validators.gender(value),
                  onTap: () =>
                      context.read<AuthCubit>().openGenderPicker(context),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.md),

        AppStaggeredAnimation(
          index: 6,
          child: Row(
            children: [
              Expanded(
                child: AppPickerField<double>(
                  label: 'height'.tr,
                  hint: 'select'.tr,
                  value: context.read<AuthCubit>().height,
                  fillColor: AppColors.gray,
                  displayText: (h) => '${h.toInt()} cm',
                  validator: (value) => Validators.height(value),
                  onTap: () =>
                      context.read<AuthCubit>().openHeightPicker(context),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: AppPickerField<double>(
                  label: 'weight'.tr,
                  hint: 'select'.tr,
                  value: context.read<AuthCubit>().weight,
                  fillColor: AppColors.gray,
                  displayText: (w) => '${w.toInt()} kg',
                  validator: (value) => Validators.weight(value),
                  onTap: () =>
                      context.read<AuthCubit>().openWeightPicker(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
