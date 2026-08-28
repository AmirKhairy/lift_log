import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/user_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';

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
          _ProfileInfoRow(label: 'full_name'.tr, value: user.name),
          _ProfileInfoRow(label: 'age'.tr, value: user.age.toString()),
          _ProfileInfoRow(
            label: 'gender'.tr,
            value: user.gender[0].toUpperCase() + user.gender.substring(1),
          ),
          _ProfileInfoRow(
            label: 'height'.tr,
            value: '${user.height.toInt()} cm',
          ),
          _ProfileInfoRow(
            label: 'weight'.tr,
            value: '${user.weight.toInt()} kg',
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

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              label,
              color: context.appColors.subtitle,
              fontSize: 14.sp,
            ),
          ),
          Expanded(
            flex: 3,
            child: AppText(
              value,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: context.theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
