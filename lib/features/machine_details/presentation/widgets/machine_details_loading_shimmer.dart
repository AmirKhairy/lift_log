import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:shimmer/shimmer.dart';

class MachineDetailsLoadingShimmer extends StatelessWidget {
  const MachineDetailsLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;

    return Shimmer.fromColors(
      baseColor: colors.surfaceContainerHighest,
      highlightColor: colors.surface,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                buildBlock(width: double.infinity, height: 200.h),
                SizedBox(height: AppSpacing.md.h),
                buildBlock(width: 150.w, height: 18.h),
                SizedBox(height: AppSpacing.md.h),
                buildBlock(width: 130.w, height: 18.h),
                SizedBox(height: AppSpacing.lg.h),
                buildBlock(width: 150.w, height: 22.h),
                SizedBox(height: AppSpacing.sm.h),
                AppCard(
                  padding: EdgeInsets.all(AppSpacing.sm.w),
                  child: Row(
                    children: [
                      buildBlock(width: 96.w, height: 64.h),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildBlock(width: double.infinity, height: 14.h),
                            SizedBox(height: AppSpacing.sm.h),
                            buildBlock(width: 90.w, height: 12.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg.h),
                buildBlock(width: 150.w, height: 22.h),
                SizedBox(height: AppSpacing.sm.h),
                AppCard(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md.w,
                    vertical: AppSpacing.sm.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: buildBlock(width: 100.w, height: 36.h)),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(child: buildBlock(width: 100.w, height: 36.h)),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                buildBlock(width: double.infinity, height: 150.h),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          buildBlock(width: double.infinity, height: 52.h),
        ],
      ),
    );
  }

  Widget buildBlock({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.sm.r),
      ),
    );
  }
}
