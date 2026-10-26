import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

import '../../../../core/utils/app_padding.dart';
import 'onboarding_panel_decoration.dart';

class OnboardingMetricTile extends StatelessWidget {
  const OnboardingMetricTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.screen,
      decoration: onboardingPanelDecoration(
        context,
        color: context.theme.colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: context.theme.colorScheme.primary, size: 22),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            title.tr,
            style: TextStyle(
              color: context.theme.colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppText(
            subtitle.tr,
            style: TextStyle(color: context.appColors.subtitle, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
