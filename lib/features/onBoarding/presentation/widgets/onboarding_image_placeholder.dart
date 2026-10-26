import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';

import 'onboarding_panel_decoration.dart';

class OnboardingImagePlaceholder extends StatelessWidget {
  const OnboardingImagePlaceholder({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: onboardingPanelDecoration(context),
      child: Center(
        child: Icon(icon, color: context.theme.colorScheme.primary, size: 44),
      ),
    );
  }
}
