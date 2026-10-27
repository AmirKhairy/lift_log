import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

class TutorialVideosLoading extends StatelessWidget {
  const TutorialVideosLoading({super.key, required this.isVertical});

  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    final baseColor = context.theme.colorScheme.surfaceContainerHighest;
    final highlightColor = context.theme.colorScheme.surface;

    final shimmer = Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        padding: isVertical
            ? EdgeInsets.only(bottom: AppSpacing.md.h)
            : EdgeInsets.zero,
        scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (_, _) => SizedBox(
          width: isVertical ? 0 : AppSpacing.sm,
          height: isVertical ? AppSpacing.md.h : 0,
        ),
        itemBuilder: (_, _) {
          return Container(
            width: isVertical ? double.infinity : 190.w,
            height: isVertical ? 142.h : null,
            padding: EdgeInsets.all(AppSpacing.sm.w),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.nm),
            ),
          );
        },
      ),
    );

    return isVertical ? shimmer : SizedBox(height: 118.h, child: shimmer);
  }
}
