import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/widgets/app_text.dart';

Future<bool?> showMachineDetailsDeleteDialog({required BuildContext context}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: AppText(
          'delete_machine',
          color: context.theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        content: AppText(
          'delete_machine_confirmation',
          color: context.theme.colorScheme.onSurface,
          fontSize: 16.sp,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: AppText(
              'cancel',
              color: context.theme.colorScheme.primary,
              fontSize: 16.sp,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: AppText(
              'delete',
              color: context.theme.colorScheme.error,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      );
    },
  );
}
