import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class OnboardingItem {
  const OnboardingItem({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.icon,
    required this.visualType,
    this.badge,
  });

  final String title;
  final String description;
  final String buttonText;
  final IconData icon;
  final OnboardingVisualType visualType;
  final String? badge;
}

enum OnboardingVisualType { machines, videos, analytics, start }

List<OnboardingItem> onboardingItems(AppLocalizations l10n) {
  return [
    OnboardingItem(
      title: l10n.onboardingTrackTitle,
      description: l10n.onboardingTrackDescription,
      buttonText: l10n.next,
      icon: Icons.fitness_center_rounded,
      visualType: OnboardingVisualType.machines,
    ),
    OnboardingItem(
      title: l10n.onboardingPerfectTitle,
      description: l10n.onboardingPerfectDescription,
      buttonText: l10n.next,
      icon: Icons.play_circle_fill_rounded,
      visualType: OnboardingVisualType.videos,
    ),
    OnboardingItem(
      title: l10n.onboardingGainsTitle,
      description: l10n.onboardingGainsDescription,
      buttonText: l10n.onboardingContinueToInsights,
      icon: Icons.trending_up_rounded,
      visualType: OnboardingVisualType.analytics,
    ),
    OnboardingItem(
      title: l10n.onboardingStartTitle,
      description: l10n.onboardingStartDescription,
      buttonText: l10n.onboardingGetStarted,
      icon: Icons.fitness_center_rounded,
      visualType: OnboardingVisualType.start,
    ),
  ];
}
