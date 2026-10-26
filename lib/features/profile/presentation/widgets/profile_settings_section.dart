import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/services/theme_service.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_picker.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/i18n/localization_service.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_settings_row.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: AppPadding.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'app_settings'.tr,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: context.theme.colorScheme.onSurface,
          ),
          SizedBox(height: AppSpacing.md),
          ProfileSettingsRow(
            label: 'language'.tr,
            value: _currentLanguageLabel(),
            onTap: () => _openLanguagePicker(context),
          ),
          SizedBox(height: AppSpacing.sm),
          ProfileSettingsRow(
            label: 'theme'.tr,
            value: _currentThemeLabel(),
            onTap: () => _openThemePicker(context),
          ),
        ],
      ),
    );
  }

  String _currentLanguageLabel() {
    final code = LocalizationService.instance.locale.languageCode;
    return code == 'ar' ? 'arabic'.tr : 'english'.tr;
  }

  String _currentThemeLabel() {
    final mode = ThemeService.instance.themeMode;
    return mode == ThemeMode.light ? 'light_theme'.tr : 'dark_theme'.tr;
  }

  Future<void> _openLanguagePicker(BuildContext context) async {
    final languages = ['ar', 'en'];
    final current = LocalizationService.instance.locale.languageCode;

    final selected = await AppPicker.show<String>(
      context: context,
      items: languages,
      itemLabel: (code) => code == 'ar' ? 'arabic'.tr : 'english'.tr,
      initialValue: current,
      pickerTitle: 'language',
    );

    if (selected != null) {
      await LocalizationService.instance.changeLanguage(selected);
    }
  }

  Future<void> _openThemePicker(BuildContext context) async {
    final themes = [ThemeMode.light, ThemeMode.dark];
    final current = ThemeService.instance.themeMode;

    final selected = await AppPicker.show<ThemeMode>(
      context: context,
      items: themes,
      itemLabel: (mode) =>
          mode == ThemeMode.light ? 'light_theme'.tr : 'dark_theme'.tr,
      initialValue: current,
      pickerTitle: 'theme',
    );

    if (selected != null) {
      await ThemeService.instance.setThemeMode(selected);
    }
  }
}
