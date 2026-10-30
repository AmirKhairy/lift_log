import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';

class RoutineNameDialog extends StatefulWidget {
  const RoutineNameDialog({super.key});

  @override
  State<RoutineNameDialog> createState() => _RoutineNameDialogState();
}

class _RoutineNameDialogState extends State<RoutineNameDialog> {
  final _controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('routine_name'.tr),
      content: Form(
        key: formKey,
        child: AppTextField(
          controller: _controller,
          hint: 'routine_name_hint',
          validator: (p0) {
            if (p0 == null || p0.trim().isEmpty) {
              return 'routine_name_required'.tr;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr),
        ),
        AppButton(
          title: 'save'.tr,
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            final name = _controller.text.trim();
            if (name.isNotEmpty) Navigator.pop(context, name);
          },
        ),
      ],
    );
  }
}
