import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/app_assets.dart';

import 'onboarding_image_panel.dart';

class OnboardingStartVisual extends StatelessWidget {
  const OnboardingStartVisual({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: OnboardingImagePanel(
        assetPath: AppAssets.onboardingStart,
        icon: icon,
      ),
    );
  }
}
