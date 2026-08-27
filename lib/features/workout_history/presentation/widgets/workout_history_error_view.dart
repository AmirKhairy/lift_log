import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';

class WorkoutHistoryErrorView extends StatelessWidget {
  const WorkoutHistoryErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${'workout_history_error'.tr}: $message'),
          SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text('retry'.tr),
          ),
        ],
      ),
    );
  }
}
