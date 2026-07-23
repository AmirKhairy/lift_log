import 'package:flutter/material.dart';
import 'package:lift_log/core/widgets/app_text.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/app_padding.dart';
import '../../../../core/utils/app_radius.dart';
import '../../models/onboarding_item.dart';
import 'onboarding_visual.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key, required this.item});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xffA8C4FF),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  item.icon,
                  size: 17,
                  color: const Color(0xff102A5C),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppText(
                'LiftLog',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (item.badge case final badge?)
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.36),
                ),
              ),
              child: AppText(
                badge,
                style: AppTextStyles.label.copyWith(
                  color: const Color(0xffA8C4FF),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          AppText(
            item.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headline.copyWith(
              color: AppColors.white,
              height: 1.04,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppText(
            item.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.subtitleDark,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OnboardingVisual(type: item.visualType, icon: item.icon),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
