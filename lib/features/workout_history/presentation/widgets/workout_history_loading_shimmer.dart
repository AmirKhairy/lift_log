import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

class WorkoutHistoryLoadingShimmer extends StatelessWidget {
  const WorkoutHistoryLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;

    return Shimmer.fromColors(
      baseColor: colors.surfaceContainerHighest,
      highlightColor: colors.surface,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          buildDaySection(),
          SizedBox(height: AppSpacing.lg.h),
          buildDaySection(),
        ],
      ),
    );
  }

  Widget buildDaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            buildBlock(width: 48.w, height: 48.w, isCircular: true),
            SizedBox(width: AppSpacing.nm.w),
            buildBlock(width: 180.w, height: 18.h),
          ],
        ),
        SizedBox(height: AppSpacing.nm.h),
        buildSessionCard(),
        SizedBox(height: AppSpacing.sm.h),
        buildSessionCard(),
      ],
    );
  }

  Widget buildSessionCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
      ),
      child: Row(
        children: [
          buildBlock(width: 40.w, height: 40.w, isCircular: true),
          SizedBox(width: AppSpacing.nm.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBlock(width: 130.w, height: 16.h),
                SizedBox(height: AppSpacing.sm.h),
                buildBlock(width: 100.w, height: 13.h),
              ],
            ),
          ),
          buildBlock(width: 22.w, height: 22.w, isCircular: true),
        ],
      ),
    );
  }

  Widget buildBlock({
    required double width,
    required double height,
    bool isCircular = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isCircular
            ? BorderRadius.circular(width / 2)
            : BorderRadius.circular(AppSpacing.sm.r),
      ),
    );
  }
}
