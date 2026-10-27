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
    this.label,
    required this.animation,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String? label;
  final Animation<double> animation;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = textColor ?? context.theme.colorScheme.onSurface;
    final accent = iconColor ?? context.theme.colorScheme.primary;

    return AnimatedBuilder(
      animation: animation,
      child: Material(
        color: backgroundColor ?? context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Container(
            height: 190.h,
            padding: AppPadding.card,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: accent.withValues(alpha: 0.16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(icon, size: 24.sp, color: accent),
                      ),
                    ),
                    if (onTap != null)
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 20.sp,
                        color: foreground.withValues(alpha: 0.55),
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                AppText(
                  value,
                  color: textColor,
                  fontSize: label == null ? 16.sp : 26.sp,
                  fontWeight: FontWeight.w700,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (label != null) ...[
                  SizedBox(height: AppSpacing.xs),
                  AppText(
                    label!,
                    color: foreground.withValues(alpha: 0.65),
                    fontSize: 13.sp,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      builder: (context, child) {
        final progress = animation.value;
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - progress)),
            child: Transform.scale(
              scale: 0.94 + (0.06 * progress),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
