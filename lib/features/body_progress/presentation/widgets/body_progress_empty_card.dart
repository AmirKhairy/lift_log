import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class BodyProgressEmptyCard extends StatelessWidget {
  const BodyProgressEmptyCard({super.key});
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      children: [
        Icon(
          Icons.monitor_weight_outlined,
          size: 52,
          color: context.theme.colorScheme.primary,
        ),
        SizedBox(height: AppSpacing.sm),
        AppText('body_progress_empty', textAlign: TextAlign.center),
      ],
    ),
  );
}
