import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_assets.dart';

import '../../../../core/utils/app_padding.dart';
import 'onboarding_image_panel.dart';
import 'onboarding_lift_stat.dart';
import 'onboarding_panel_decoration.dart';

class OnboardingAnalyticsVisual extends StatelessWidget {
  const OnboardingAnalyticsVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: AppPadding.screen,
          decoration: onboardingPanelDecoration(context),
          child: Row(
            children: [
              const OnboardingLiftStat(label: 'barbell_squat', value: '140 kg'),
              const Spacer(),
              const OnboardingLiftStat(label: 'sets', value: '5'),
              const SizedBox(width: AppSpacing.md),
              const OnboardingLiftStat(label: 'reps', value: '8'),
              const SizedBox(width: AppSpacing.md),
              CircleAvatar(
                radius: 18,
                backgroundColor: context.theme.colorScheme.primary,
                child: Icon(
                  Icons.check_rounded,
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Expanded(
          child: OnboardingImagePanel(
            assetPath: AppAssets.onboardingInsights,
            icon: Icons.insights_rounded,
          ),
        ),
      ],
    );
  }
}
