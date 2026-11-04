import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/i18n/localization_service.dart';

class OnboardingLanguageButton extends StatelessWidget {
  const OnboardingLanguageButton({
    super.key,
    required this.languageCode,
    required this.labelKey,
  });

  final String languageCode;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LocalizationService.instance,
      builder: (context, child) {
        final isSelected =
            LocalizationService.instance.locale.languageCode == languageCode;
        final colors = context.theme.colorScheme;

        return Semantics(
          button: true,
          selected: isSelected,
          label: labelKey.tr,
          child: TextButton(
            onPressed: isSelected
                ? null
                : () =>
                      LocalizationService.instance.changeLanguage(languageCode),
            style: TextButton.styleFrom(
              minimumSize: const Size(40, 32),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              foregroundColor: isSelected ? colors.secondary : colors.primary,
              backgroundColor: isSelected ? colors.primary : colors.surface,
              side: BorderSide(color: colors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              languageCode.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        );
      },
    );
  }
}
