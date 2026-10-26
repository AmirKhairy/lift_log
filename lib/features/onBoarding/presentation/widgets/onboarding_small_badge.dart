import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_text.dart';

import '../../../../core/theme/app_spacing.dart';

class OnboardingSmallBadge extends StatelessWidget {
  const OnboardingSmallBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: AppText(
        label.tr,
        style: TextStyle(
          color: context.theme.colorScheme.onSurface,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
