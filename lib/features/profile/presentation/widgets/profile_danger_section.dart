import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class ProfileDangerSection extends StatelessWidget {
  const ProfileDangerSection({
    super.key,
    required this.onLogout,
    required this.onDeleteAccount,
    required this.isLoggingOut,
    required this.isDeletingAccount,
  });

  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;
  final bool isLoggingOut;
  final bool isDeletingAccount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: AppPadding.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'danger_zone'.tr,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: context.theme.colorScheme.error,
          ),
          SizedBox(height: AppSpacing.md),
          AppButton(
            title: 'logout',
            loading: isLoggingOut,
            onPressed: isDeletingAccount ? null : onLogout,
            backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
            textColor: context.theme.colorScheme.onSurface,
          ),
          SizedBox(height: AppSpacing.sm),
          AppButton(
            title: 'delete_account',
            loading: isDeletingAccount,
            onPressed: isLoggingOut ? null : onDeleteAccount,
            backgroundColor: context.theme.colorScheme.error,
            textColor: context.theme.colorScheme.onError,
          ),
        ],
      ),
    );
  }
}
