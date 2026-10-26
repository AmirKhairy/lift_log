import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_text.dart';

import 'onboarding_image_panel.dart';

class OnboardingThumbnail extends StatelessWidget {
  const OnboardingThumbnail({
    super.key,
    required this.label,
    required this.image,
  });

  final String label;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: OnboardingImagePanel(
        assetPath: image,
        icon: Icons.image_rounded,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: AppPadding.screen,
            child: AppText(
              label.tr,
              style: TextStyle(
                color: context.theme.colorScheme.onSurface,
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
