import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/body_progress_models.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'body_progress_section_card.dart';

class BodyProgressHistoryCard extends StatelessWidget {
  const BodyProgressHistoryCard({
    super.key,
    required this.entries,
    required this.onEdit,
    required this.onDelete,
    this.currentEntryId,
    this.deletingId,
    this.isSaving = false,
  });
  final List<BodyWeightEntry> entries;
  final ValueChanged<BodyWeightEntry> onEdit;
  final ValueChanged<String> onDelete;
  final String? currentEntryId;
  final String? deletingId;
  final bool isSaving;
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return BodyProgressSectionCard(
      title: 'weight_history',
      child: Column(
        children: [
          for (final entry in entries.reversed.take(20))
            _buildEntryTile(context, entry, locale),
        ],
      ),
    );
  }

  Widget _buildEntryTile(
    BuildContext context,
    BodyWeightEntry entry,
    String locale,
  ) {
    final isCurrent = entry.id == currentEntryId;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('${entry.weight.toStringAsFixed(1)} ${'weight_unit'.tr}'),
      subtitle: Text(
        DateFormat.yMMMd(locale).add_jm().format(entry.measuredAt),
      ),
      trailing: isCurrent
          ? const AppText('your_current_weight')
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: isSaving || deletingId != null
                      ? null
                      : () => onEdit(entry),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: isSaving || deletingId != null
                      ? null
                      : () => onDelete(entry.id),
                  icon: deletingId == entry.id
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline),
                ),
              ],
            ),
    );
  }
}
