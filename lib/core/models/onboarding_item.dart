import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';

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

List<OnboardingItem> onboardingItems() {
  return [
    OnboardingItem(
      title: 'onboarding_track_title'.tr,
      description: 'onboarding_track_description'.tr,
      buttonText: 'next'.tr,
      icon: Icons.fitness_center_rounded,
      visualType: OnboardingVisualType.machines,
    ),
    OnboardingItem(
      title: 'onboarding_perfect_title'.tr,
      description: 'onboarding_perfect_description'.tr,
      buttonText: 'next'.tr,
      icon: Icons.play_circle_fill_rounded,
      visualType: OnboardingVisualType.videos,
    ),
    OnboardingItem(
      title: 'onboarding_gains_title'.tr,
      description: 'onboarding_gains_description'.tr,
      buttonText: 'continue_to_insights'.tr,
      icon: Icons.trending_up_rounded,
      visualType: OnboardingVisualType.analytics,
    ),
    OnboardingItem(
      title: 'onboarding_start_title'.tr,
      description: 'onboarding_start_description'.tr,
      buttonText: 'get_started'.tr,
      icon: Icons.fitness_center_rounded,
      visualType: OnboardingVisualType.start,
    ),
  ];
}
