import 'package:flutter/material.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class AppSnackbar {
  static void success({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: AppText(message),
      duration: duration,
      backgroundColor: AppColors.success,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void error({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: AppColors.error,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
