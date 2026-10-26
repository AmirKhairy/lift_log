import 'package:flutter/material.dart';
import 'package:lift_log/core/models/onboarding_item.dart';

import 'onboarding_analytics_visual.dart';
import 'onboarding_machine_visual.dart';
import 'onboarding_start_visual.dart';
import 'onboarding_video_visual.dart';

class OnboardingVisual extends StatelessWidget {
  const OnboardingVisual({super.key, required this.type, required this.icon});

  final OnboardingVisualType type;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: switch (type) {
        OnboardingVisualType.machines => const OnboardingMachineVisual(),
        OnboardingVisualType.videos => const OnboardingVideoVisual(),
        OnboardingVisualType.analytics => const OnboardingAnalyticsVisual(),
        OnboardingVisualType.start => OnboardingStartVisual(icon: icon),
      },
    );
  }
}
