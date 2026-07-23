import 'package:flutter/material.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    this.onPressed,
    this.loading = false,
    this.width,
    this.height = 52,
    this.icon,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool loading;
  final double? width;
  final double height;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: FilledButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : icon ?? const SizedBox.shrink(),
        label: AppText(title),
      ),
    );
  }
}
