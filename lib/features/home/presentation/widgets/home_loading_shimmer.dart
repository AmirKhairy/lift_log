import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:shimmer/shimmer.dart';

class HomeLoadingShimmer extends StatelessWidget {
  const HomeLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.theme.colorScheme.surfaceContainerHighest;
    final highlightColor = context.theme.colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppBar(context),

            SizedBox(height: AppSpacing.sm),

            _buildWorkoutOverview(context),

            SizedBox(height: AppSpacing.md),

            _buildStats(context),

            SizedBox(height: AppSpacing.md),

            _buildCalendar(context),

            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: AppPadding.xs,
      child: Row(
        children: [
          _ShimmerBox(width: 52.w, height: 52.w, shape: BoxShape.circle),

          SizedBox(width: AppSpacing.sm),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(width: 110.w, height: 14.h),

              SizedBox(height: AppSpacing.xs),

              _ShimmerBox(width: 90.w, height: 14.h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutOverview(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: AppPadding.xs,
      height: 108.h,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: 170.w, height: 18.h),

          SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _ShimmerBox(width: 28.w, height: 28.w),

                    SizedBox(width: AppSpacing.sm),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(width: 25.w, height: 20.h),

                        SizedBox(height: AppSpacing.xs),

                        _ShimmerBox(width: 85.w, height: 10.h),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Row(
                  children: [
                    _ShimmerBox(width: 28.w, height: 28.w),

                    SizedBox(width: AppSpacing.sm),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(width: 45.w, height: 20.h),

                        SizedBox(height: AppSpacing.xs),

                        _ShimmerBox(width: 75.w, height: 10.h),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(child: _buildStatCard(context)),

          SizedBox(width: AppSpacing.sm),

          Expanded(child: _buildStatCard(context)),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context) {
    return Container(
      height: 112.h,
      padding: AppPadding.xs,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ShimmerBox(width: 30.w, height: 30.w),

          SizedBox(height: AppSpacing.sm),

          _ShimmerBox(width: 25.w, height: 22.h),

          SizedBox(height: AppSpacing.xs),

          _ShimmerBox(width: 55.w, height: 12.h),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: AppPadding.xs,
      height: 310.h,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: 145.w, height: 18.h),

          SizedBox(height: AppSpacing.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBox(width: 24.w, height: 24.w, shape: BoxShape.circle),

              _ShimmerBox(width: 110.w, height: 18.h),

              _ShimmerBox(width: 24.w, height: 24.w, shape: BoxShape.circle),
            ],
          ),

          SizedBox(height: AppSpacing.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              7,
              (_) => _ShimmerBox(width: 25.w, height: 12.h),
            ),
          ),

          SizedBox(height: AppSpacing.md),

          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 35,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
              ),
              itemBuilder: (_, index) {
                return const _ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                  shape: BoxShape.circle,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
  });

  final double width;
  final double height;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onSurface,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(6.r)
            : null,
      ),
    );
  }
}
