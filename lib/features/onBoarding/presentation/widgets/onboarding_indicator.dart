import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_radius.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.length,
    required this.currentIndex,
  });

  final int length;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          width: isActive ? AppSpacing.lg : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            color: isActive
                ? context.theme.colorScheme.primary
                : context.theme.colorScheme.onSurface.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        );
      }),
    );
  }
}
