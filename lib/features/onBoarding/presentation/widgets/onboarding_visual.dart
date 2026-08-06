import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/widgets/app_text.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_padding.dart';
import '../../../../core/utils/app_radius.dart';
import '../../models/onboarding_item.dart';

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
        OnboardingVisualType.machines => const _MachineVisual(),
        OnboardingVisualType.videos => const _VideoVisual(),
        OnboardingVisualType.analytics => const _InsightsVisual(),
        OnboardingVisualType.start => _StartVisual(icon: icon),
      },
    );
  }
}

class _MachineVisual extends StatelessWidget {
  const _MachineVisual();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _ImagePanel(
            assetPath: AppAssets.onboardingMachine,
            icon: Icons.insights_rounded,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                icon: Icons.tune_rounded,
                title: 'precision'.tr,
                subtitle: 'pin_position'.tr,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MetricTile(
                icon: Icons.history_rounded,
                title: 'history'.tr,
                subtitle: 'weight_loads'.tr,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VideoVisual extends StatelessWidget {
  const _VideoVisual();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _ImagePanel(
            assetPath: AppAssets.onboardingVideo,
            icon: Icons.play_circle_fill_rounded,
            child: Stack(
              children: [
                Positioned(
                  left: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      AppText(
                        'proper_deadlift_form'.tr,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: AppSpacing.md,
                  top: AppSpacing.md,
                  child: _SmallBadge(label: 'featured'.tr),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _Thumbnail(
                label: 'bench_press'.tr,
                image: AppAssets.onboardingBenchPress,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Thumbnail(
                label: 'caple_row'.tr,
                image: AppAssets.onboardingCapleRow,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InsightsVisual extends StatelessWidget {
  const _InsightsVisual();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: AppPadding.screen,
          decoration: _panelDecoration(),
          child: Row(
            children: [
              _LiftStat(label: 'barbell_squat'.tr, value: '140 kg'),
              const Spacer(),
              _LiftStat(label: 'sets'.tr, value: '5'),
              const SizedBox(width: AppSpacing.md),
              _LiftStat(label: 'reps'.tr, value: '8'),
              const SizedBox(width: AppSpacing.md),
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.check_rounded, color: AppColors.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: _ImagePanel(
            assetPath: AppAssets.onboardingInsights,
            icon: Icons.insights_rounded,
          ),
        ),
      ],
    );
  }
}

class _StartVisual extends StatelessWidget {
  const _StartVisual({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: _ImagePanel(
        assetPath: AppAssets.onboardingStart,
        icon: Icons.image_rounded,
      ),
    );
  }
}

class _ImagePanel extends StatelessWidget {
  const _ImagePanel({required this.assetPath, required this.icon, this.child});

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
              return _ImagePlaceholder(icon: icon);
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black.withValues(alpha: 0.08),
                  AppColors.black.withValues(alpha: 0.48),
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

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _panelDecoration(),
      child: Center(
        child: Icon(icon, color: const Color(0xffA8C4FF), size: 44),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
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
      decoration: _panelDecoration(color: AppColors.surfaceVariantDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xffA8C4FF), size: 22),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            title.tr,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppText(
            subtitle.tr,
            style: const TextStyle(color: AppColors.subtitleDark, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.label, required this.image});

  final String label;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: _ImagePanel(
        assetPath: image,
        icon: Icons.image_rounded,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: AppPadding.screen,
            child: AppText(
              label.tr,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiftStat extends StatelessWidget {
  const _LiftStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label.toUpperCase(),
          style: const TextStyle(color: AppColors.subtitleDark, fontSize: 9),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppText(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: AppText(
        label.tr,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

BoxDecoration _panelDecoration({Color color = AppColors.surfaceDark}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(AppRadius.sm),
    border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
  );
}
