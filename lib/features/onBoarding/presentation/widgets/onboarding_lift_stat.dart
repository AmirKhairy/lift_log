import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class OnboardingLiftStat extends StatelessWidget {
  const OnboardingLiftStat({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label.tr.toUpperCase(),
          style: TextStyle(color: context.appColors.subtitle, fontSize: 9),
        ),
        const SizedBox(height: 4),
        AppText(
          value,
          style: TextStyle(
            color: context.theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
