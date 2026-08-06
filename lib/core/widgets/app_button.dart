import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/loading.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    this.onPressed,
    this.loading = false,
    this.width,
    this.height = 52,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool loading;
  final double? width;
  final double height;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: FilledButton.icon(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? AppColors.primary,
          ),
        ),
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox.shrink()
            : icon ?? const SizedBox.shrink(),
        label: loading
            ? const Loading()
            : AppText(title.tr, color: textColor ?? AppColors.white),
      ),
    );
  }
}
