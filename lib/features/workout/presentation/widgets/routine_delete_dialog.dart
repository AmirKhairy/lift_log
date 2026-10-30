import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';

class RoutineDeleteDialog extends StatelessWidget {
  const RoutineDeleteDialog({super.key, required this.routineName});

  final String routineName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('delete_routine'.tr),
      content: Text('${'delete_routine_confirmation'.tr}\n\n$routineName'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('cancel'.tr),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text('delete'.tr),
        ),
      ],
    );
  }
}
