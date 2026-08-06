import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/helpers/validators.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_labeled_text_field.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';

class RegesterCardAccountDetailsSection extends StatelessWidget {
  const RegesterCardAccountDetailsSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.userIdFromGoogle,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String userIdFromGoogle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppStaggeredAnimation(
          index: 1,
          child: LabeledTextField(
            label: 'full_name'.tr,
            child: AppTextField(
              enabled: userIdFromGoogle.isEmpty,
              controller: nameController,
              hint: 'John Doe',
              hintColor: AppColors.subtitleDark,
              keyboardType: TextInputType.name,
              prefixIcon: const Icon(
                Icons.person_outline,
                color: AppColors.white,
              ),
              filled: true,
              fillColor: AppColors.gray,
              validator: (value) => Validators.name(value),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        AppStaggeredAnimation(
          index: 2,
          child: LabeledTextField(
            label: 'email'.tr,
            child: AppTextField(
              enabled: userIdFromGoogle.isEmpty,
              controller: emailController,
              hint: 'name@example.com',
              hintColor: AppColors.subtitleDark,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppColors.white,
              ),
              filled: true,
              fillColor: AppColors.gray,
              validator: (value) => Validators.email(value),
            ),
          ),
        ),
        if (userIdFromGoogle.isEmpty) SizedBox(height: AppSpacing.md),
        if (userIdFromGoogle.isEmpty)
          AppStaggeredAnimation(
            index: 3,
            child: LabeledTextField(
              label: 'password'.tr,
              child: AppTextField(
                controller: passwordController,
                hint: '••••••••',
                hintColor: AppColors.subtitleDark,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                obscureIconColor: AppColors.white,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.white,
                ),
                filled: true,
                fillColor: AppColors.gray,
                validator: (value) => Validators.password(
                  value,
                  skip: userIdFromGoogle.isNotEmpty,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
