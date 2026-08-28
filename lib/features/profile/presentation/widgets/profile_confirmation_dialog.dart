import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/widgets/app_text.dart';

Future<bool?> showProfileConfirmationDialog({
  required BuildContext context,
  required String titleKey,
  required String messageKey,
  required String confirmKey,
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: AppText(
          titleKey.tr,
          color: context.theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        content: AppText(
          messageKey.tr,
          color: context.theme.colorScheme.onSurface,
          fontSize: 16.sp,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: AppText(
              'cancel'.tr,
              color: context.theme.colorScheme.primary,
              fontSize: 16.sp,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: AppText(
              confirmKey.tr,
              color: isDestructive
                  ? context.theme.colorScheme.error
                  : context.theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      );
    },
  );
}
