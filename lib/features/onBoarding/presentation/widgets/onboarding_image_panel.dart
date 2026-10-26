import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/utils/app_radius.dart';

import 'onboarding_image_placeholder.dart';

class OnboardingImagePanel extends StatelessWidget {
  const OnboardingImagePanel({
    super.key,
    required this.assetPath,
    required this.icon,
    this.child,
  });

  final String assetPath;
  final IconData icon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return OnboardingImagePlaceholder(icon: icon);
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.theme.colorScheme.onSurface.withValues(alpha: 0.08),
                  context.theme.colorScheme.onSurface.withValues(alpha: 0.48),
                ],
              ),
            ),
          ),
          ?child,
        ],
      ),
    );
  }
}
