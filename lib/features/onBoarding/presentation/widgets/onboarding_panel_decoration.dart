import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/utils/app_radius.dart';

BoxDecoration onboardingPanelDecoration(
  BuildContext context, {
  Color? color,
}) {
  return BoxDecoration(
    color: color ?? context.theme.colorScheme.surface,
    borderRadius: BorderRadius.circular(AppRadius.sm),
    border: Border.all(
      color: context.theme.dividerColor.withValues(alpha: 0.08),
    ),
  );
}
