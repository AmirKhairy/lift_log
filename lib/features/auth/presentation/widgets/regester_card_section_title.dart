import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class RegesterCardSectionTitle extends StatelessWidget {
  const RegesterCardSectionTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 3,
          height: 24,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primary,
            shape: BoxShape.rectangle,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppText(
          title.tr,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
