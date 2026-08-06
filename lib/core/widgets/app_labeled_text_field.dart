import 'package:flutter/material.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
