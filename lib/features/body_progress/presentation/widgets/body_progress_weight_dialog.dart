import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/body_progress_models.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';

class BodyProgressWeightDialog extends StatefulWidget {
  const BodyProgressWeightDialog({super.key, this.entry, required this.onSave});
  final BodyWeightEntry? entry;
  final Future<void> Function(double weight, DateTime date) onSave;
  @override
  State<BodyProgressWeightDialog> createState() =>
      BodyProgressWeightDialogState();
}

class BodyProgressWeightDialogState extends State<BodyProgressWeightDialog> {
  late final TextEditingController controller = TextEditingController(
    text: widget.entry?.weight.toString() ?? '',
  );
  final _formKey = GlobalKey<FormState>();
  late DateTime date = widget.entry?.measuredAt ?? DateTime.now();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: AppText(widget.entry == null ? 'add_weight' : 'edit_weight'),
    content: Form(
      key: _formKey,
      child: AppTextField(
        controller: controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
        ],
        hint: 'weight',
        validator: (p0) {
          if (p0 == null || p0.isEmpty) {
            return 'weight_required'.tr;
          }
          return null;
        },
      ),
    ),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: context.colors.onSurface,
          ),
          TextButton(onPressed: _chooseDate, child: AppText('choose_date')),
        ],
      ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: AppText('cancel'),
      ),
      FilledButton(onPressed: _save, child: AppText('save')),
    ],
  );
  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: date,
    );
    if (picked != null) {
      setState(
        () => date = DateTime(
          picked.year,
          picked.month,
          picked.day,
          date.hour,
          date.minute,
        ),
      );
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final weight = double.tryParse(controller.text);
    if (weight == null) return;
    Navigator.pop(context);
    widget.onSave(weight, date);
  }
}
