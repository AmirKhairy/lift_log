import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.animation,
  });

  final IconData icon;
  final String value;
  final String label;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: Container(
        padding: AppPadding.xs,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30.sp, color: context.theme.colorScheme.primary),

            SizedBox(height: AppSpacing.sm),

            AppText(value, fontSize: 24.sp, fontWeight: FontWeight.w700),

            SizedBox(height: AppSpacing.xs),

            AppText(
              label,
              color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
      builder: (context, child) {
        final scale = Tween<double>(begin: 0.9, end: 1.0).evaluate(animation);

        final opacity = Tween<double>(begin: 0, end: 1).evaluate(animation);

        final offset = Tween<double>(begin: 20, end: 0).evaluate(animation);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, offset),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
    );
  }
}
