import 'package:flutter/material.dart';
import 'package:lift_log/core/models/body_progress_models.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';

class BodyProgressGoalDialog extends StatefulWidget {
  const BodyProgressGoalDialog({super.key, this.goal, required this.onSave});
  final WeightGoal? goal;
  final Future<void> Function(double targetWeight) onSave;
  @override
  State<BodyProgressGoalDialog> createState() => BodyProgressGoalDialogState();
}

class BodyProgressGoalDialogState extends State<BodyProgressGoalDialog> {
  late final TextEditingController controller = TextEditingController(
    text: widget.goal?.targetWeight.toString() ?? '',
  );
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const AppText('target_weight'),
    content: AppTextField(
      controller: controller,
      autofocus: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      hint: 'weight',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: AppText('cancel'),
      ),
      FilledButton(onPressed: _save, child: AppText('save')),
    ],
  );
  void _save() {
    final value = double.tryParse(controller.text);
    if (value == null) return;
    Navigator.pop(context);
    widget.onSave(value);
  }
}
