import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_assets.dart';
import 'package:lift_log/core/widgets/app_text.dart';

import 'onboarding_image_panel.dart';
import 'onboarding_small_badge.dart';
import 'onboarding_thumbnail.dart';

class OnboardingVideoVisual extends StatelessWidget {
  const OnboardingVideoVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: OnboardingImagePanel(
            assetPath: AppAssets.onboardingVideo,
            icon: Icons.play_circle_fill_rounded,
            child: Stack(
              children: [
                Positioned(
                  left: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_circle_fill_rounded,
                        color: context.theme.colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      AppText(
                        'proper_deadlift_form'.tr,
                        style: TextStyle(
                          color: context.theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: AppSpacing.md,
                  top: AppSpacing.md,
                  child: const OnboardingSmallBadge(label: 'featured'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const Expanded(
              child: OnboardingThumbnail(
                label: 'bench_press',
                image: AppAssets.onboardingBenchPress,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: OnboardingThumbnail(
                label: 'caple_row',
                image: AppAssets.onboardingCapleRow,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
