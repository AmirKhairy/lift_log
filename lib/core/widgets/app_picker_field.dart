import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class AppPickerField<T> extends StatelessWidget {
  const AppPickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.onTap,
    required this.value,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.enabled = true,
    this.displayText,
  });

  final String label;
  final String hint;
  final T? value;

  final VoidCallback onTap;

  final String? Function(T?)? validator;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final Color? fillColor;
  final Color? hintColor;
  final Color? textColor;

  final bool enabled;

  final String Function(T value)? displayText;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      validator: (_) => validator?.call(value),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              label.tr,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: enabled ? onTap : null,
              child: InputDecorator(
                isEmpty: value == null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fillColor,
                  prefixIcon: prefixIcon,
                  suffixIcon:
                      suffixIcon ??
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.subtitleDark,
                      ),
                  errorText: field.errorText,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: AppText(
                    value == null
                        ? hint.tr
                        : displayText?.call(value as T) ?? value.toString().tr,
                    key: ValueKey(value),
                    style: TextStyle(
                      color: value == null
                          ? hintColor ?? AppColors.subtitleDark
                          : textColor ?? AppColors.textDark,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
