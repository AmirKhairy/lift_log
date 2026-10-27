import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/logic_utilities.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class PerformedAtCard extends StatelessWidget {
  const PerformedAtCard({
    super.key,
    required this.performedAt,
    required this.enabled,
    required this.onChanged,
  });

  final DateTime performedAt;
  final bool enabled;
  final void Function(DateTime date, TimeOfDay time) onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        enabled: enabled,
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        leading: CircleAvatar(
          backgroundColor: context.colors.primary.withValues(alpha: 0.12),
          child: Icon(Icons.event_rounded, color: context.colors.primary),
        ),
        title: AppText('performed_at', fontWeight: FontWeight.w600),
        subtitle: AppText(
          LogicUtilities.instance.formatDateTime(performedAt, context),
        ),
        trailing: Icon(
          Icons.edit_calendar_rounded,
          color: context.colors.primary,
        ),
        onTap: enabled
            ? () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  initialDate: performedAt,
                );
                if (date == null || !context.mounted) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(performedAt),
                );
                if (time != null && context.mounted) onChanged(date, time);
              }
            : null,
      ),
    );
  }
}
