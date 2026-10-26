import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/user_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_info_row.dart';

class ProfileDataSection extends StatelessWidget {
  const ProfileDataSection({
    super.key,
    required this.user,
    required this.onEditProfile,
    required this.onChangePassword,
  });

  final UserModel user;
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: AppPadding.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'profile_data'.tr,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: context.theme.colorScheme.onSurface,
          ),
          SizedBox(height: AppSpacing.md),
          ProfileInfoRow(label: 'full_name'.tr, value: user.name),
          ProfileInfoRow(label: 'age'.tr, value: user.age.toString()),
          ProfileInfoRow(
            label: 'gender'.tr,
            value: user.gender == 'male' ? 'male'.tr : 'female'.tr,
          ),
          ProfileInfoRow(
            label: 'height'.tr,
            value: '${user.height.toInt()} ${'height_unit'.tr}',
          ),
          ProfileInfoRow(
            label: 'weight'.tr,
            value: '${user.weight.toInt()} ${'weight_unit'.tr}',
          ),
          SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: onEditProfile,
            child: AppText(
              'edit_profile'.tr,
              color: context.theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: onChangePassword,
            child: AppText(
              'change_password'.tr,
              color: context.theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
