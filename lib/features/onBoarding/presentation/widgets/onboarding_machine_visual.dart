import 'package:flutter/material.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_assets.dart';

import 'onboarding_image_panel.dart';
import 'onboarding_metric_tile.dart';

class OnboardingMachineVisual extends StatelessWidget {
  const OnboardingMachineVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: OnboardingImagePanel(
            assetPath: AppAssets.onboardingMachine,
            icon: Icons.insights_rounded,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const Expanded(
              child: OnboardingMetricTile(
                icon: Icons.tune_rounded,
                title: 'precision',
                subtitle: 'pin_position',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: OnboardingMetricTile(
                icon: Icons.history_rounded,
                title: 'history',
                subtitle: 'weight_loads',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
