import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/body_progress_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

import 'body_progress_section_card.dart';

class BodyProgressStatisticsCard extends StatelessWidget {
  const BodyProgressStatisticsCard({super.key, required this.stats});
  final BodyProgressStats stats;
  @override
  Widget build(BuildContext context) => BodyProgressSectionCard(
    title: 'weight_statistics',
    child: Column(
      children: [
        _row(context, 'starting_weight', stats.startingWeight),
        _row(context, 'highest_weight', stats.highestWeight),
        _row(context, 'lowest_weight', stats.lowestWeight),
      ],
    ),
  );
  Widget _row(BuildContext context, String label, double? value) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Row(
      children: [
        Expanded(child: AppText(label, color: context.appColors.subtitle)),
        value == null
            ? AppText('-')
            : AppText('${value.toStringAsFixed(1)} ${'weight_unit'.tr}'),
      ],
    ),
  );
}
