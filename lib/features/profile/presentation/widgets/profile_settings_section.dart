import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/services/theme_service.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/language_switcher.dart';
import 'package:lift_log/i18n/localization_service.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_settings_row.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        LocalizationService.instance,
        ThemeService.instance,
      ]),
      builder: (context, child) {
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
                trailing: const LanguageSwitcher(),
              ),
              SizedBox(height: AppSpacing.sm),
              ProfileSettingsRow(
                label: 'theme'.tr,
                trailing: _buildThemeSwitcher(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    final current = ThemeService.instance.themeMode;

    return _buildSwitcher(
      context,
      options: [
        _SwitcherOption(
          value: ThemeMode.light,
          label: 'light_theme'.tr,
          child: const Icon(Icons.light_mode_outlined),
        ),
        _SwitcherOption(
          value: ThemeMode.dark,
          label: 'dark_theme'.tr,
          child: const Icon(Icons.dark_mode_outlined),
        ),
      ],
      selectedValue: current,
      onSelected: (value) => ThemeService.instance.setThemeMode(value),
    );
  }

  Widget _buildSwitcher<T>(
    BuildContext context, {
    required List<_SwitcherOption<T>> options,
    required T selectedValue,
    required Future<void> Function(T value) onSelected,
  }) {
    final colors = context.theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option.value == selectedValue;

          return Semantics(
            button: true,
            selected: isSelected,
            label: option.label,
            child: InkWell(
              onTap: isSelected ? null : () => onSelected(option.value),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                constraints: BoxConstraints(minWidth: 38.sp, minHeight: 34.sp),
                padding: EdgeInsets.symmetric(horizontal: 8.sp),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconTheme(
                  data: IconThemeData(
                    size: 18.sp,
                    color: isSelected ? colors.onPrimary : colors.onSurface,
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: isSelected ? colors.onPrimary : colors.onSurface,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    child: Center(child: option.child),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SwitcherOption<T> {
  const _SwitcherOption({
    required this.value,
    required this.label,
    required this.child,
  });

  final T value;
  final String label;
  final Widget child;
}
