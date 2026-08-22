import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

class VideosLoading extends StatelessWidget {
  const VideosLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.theme.colorScheme.surfaceContainerHighest;
    final highlightColor = context.theme.colorScheme.surface;

    return SizedBox(
      height: 118.h,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: AppSpacing.md.h),
          scrollDirection: Axis.vertical,
          itemCount: 3,
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md.h),
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: 142.h,
              padding: EdgeInsets.all(AppSpacing.sm.w),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.nm),
              ),
            );
          },
        ),
      ),
    );
  }
}
