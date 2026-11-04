import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:shimmer/shimmer.dart';

class ProfileLoadingShimmer extends StatelessWidget {
  const ProfileLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;

    return Shimmer.fromColors(
      baseColor: colors.surfaceContainerHighest,
      highlightColor: colors.surface,
      child: ListView(
        padding: EdgeInsets.only(bottom: AppSpacing.xl.h),
        children: [
          AppCard(
            margin: AppPadding.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBlock(width: 120.w, height: 20.h),
                SizedBox(height: AppSpacing.md.h),
                for (var index = 0; index < 5; index++) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildBlock(width: 72.w, height: 14.h),
                      buildBlock(width: 100.w, height: 14.h),
                    ],
                  ),
                  if (index < 4) SizedBox(height: AppSpacing.nm.h),
                ],
                SizedBox(height: AppSpacing.md.h),
                buildBlock(width: double.infinity, height: 40.h),
                SizedBox(height: AppSpacing.md.h),
                buildBlock(width: double.infinity, height: 40.h),
                SizedBox(height: AppSpacing.sm.h),
                buildBlock(width: double.infinity, height: 40.h),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          AppCard(
            margin: AppPadding.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBlock(width: 110.w, height: 20.h),
                SizedBox(height: AppSpacing.md.h),
                buildBlock(width: double.infinity, height: 36.h),
                SizedBox(height: AppSpacing.sm.h),
                buildBlock(width: double.infinity, height: 36.h),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          AppCard(
            margin: AppPadding.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBlock(width: 100.w, height: 20.h),
                SizedBox(height: AppSpacing.md.h),
                buildBlock(width: double.infinity, height: 46.h),
                SizedBox(height: AppSpacing.sm.h),
                buildBlock(width: double.infinity, height: 46.h),
              ],
            ),
          ),
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
