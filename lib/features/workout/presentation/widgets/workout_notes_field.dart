import 'package:flutter/material.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';

class WorkoutNotesField extends StatefulWidget {
  const WorkoutNotesField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<WorkoutNotesField> createState() => _WorkoutNotesFieldState();
}

class _WorkoutNotesFieldState extends State<WorkoutNotesField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      hint: 'workout_notes_hint',
      maxLines: 3,
      onChanged: widget.onChanged,
    );
  }
}
