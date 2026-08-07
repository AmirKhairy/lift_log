import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class AppSnackbar {
  static void success({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context: context,
      message: message.tr,
      backgroundColor: context.appColors.success,
      icon: Icons.check_circle_rounded,
      duration: duration,
    );
  }

  static void error({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context: context,
      message: message.tr,
      backgroundColor: context.theme.colorScheme.error,
      icon: Icons.error_rounded,
      duration: duration,
    );
  }

  static void info({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context: context,
      message: message.tr,
      backgroundColor: context.theme.colorScheme.primary,
      icon: Icons.info_rounded,
      duration: duration,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: duration,
          margin: const EdgeInsets.all(AppSpacing.md),
          content: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: context.theme.colorScheme.onPrimary,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppText(
                    message.tr,
                    style: TextStyle(
                      color: context.theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
