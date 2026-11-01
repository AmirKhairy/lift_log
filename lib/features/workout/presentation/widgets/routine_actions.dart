import 'package:flutter/material.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class RoutineActions extends StatelessWidget {
  const RoutineActions({
    super.key,
    required this.routines,
    required this.enabled,
    required this.onSelect,
    required this.onSave,
    this.showSelect = true,
    this.showSave = true,
    this.saveLabel = 'save_routine',
  });

  final List<RoutineModel> routines;
  final bool enabled;
  final VoidCallback onSelect;
  final VoidCallback onSave;
  final bool showSelect;
  final bool showSave;
  final String saveLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showSelect) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: enabled && routines.isNotEmpty ? onSelect : null,
              icon: const Icon(Icons.playlist_play_rounded),
              label: AppText('choose_routine'),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
        ],

        if (showSave)
          Expanded(
            child: TextButton.icon(
              onPressed: enabled ? onSave : null,
              icon: const Icon(Icons.bookmark_add_outlined),
              label: AppText(saveLabel),
            ),
          ),
      ],
    );
  }
}
