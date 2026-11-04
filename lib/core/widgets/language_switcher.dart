import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/i18n/localization_service.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LocalizationService.instance,
      builder: (context, child) {
        final colors = context.theme.colorScheme;
        final currentLanguage =
            LocalizationService.instance.locale.languageCode;

        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LanguageSwitcherOption(
                languageCode: 'ar',
                label: 'arabic'.tr,
                isSelected: currentLanguage == 'ar',
              ),
              LanguageSwitcherOption(
                languageCode: 'en',
                label: 'english'.tr,
                isSelected: currentLanguage == 'en',
              ),
            ],
          ),
        );
      },
    );
  }
}

class LanguageSwitcherOption extends StatelessWidget {
  const LanguageSwitcherOption({
    super.key,
    required this.languageCode,
    required this.label,
    required this.isSelected,
  });

  final String languageCode;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: isSelected
            ? null
            : () => LocalizationService.instance.changeLanguage(languageCode),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: BoxConstraints(minWidth: 38.sp, minHeight: 34.sp),
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: AppText(
              languageCode.toUpperCase(),
              color: isSelected ? colors.onPrimary : colors.onSurface,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
