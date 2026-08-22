import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

class AddMachineLoading extends StatelessWidget {
  const AddMachineLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.theme.colorScheme.surfaceContainerHighest;
    final highlightColor = context.theme.colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _block(context, height: 170.h),
          SizedBox(height: AppSpacing.lg),
          _line(context, width: 110.w),
          SizedBox(height: AppSpacing.sm),
          _block(context, height: 56.h),
          SizedBox(height: AppSpacing.md),
          _line(context, width: 150.w),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: List.generate(
              6,
              (index) => _pill(context, width: 72.w + (index % 2) * 18.w),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          _line(context, width: 130.w),
          SizedBox(height: AppSpacing.sm),
          _block(context, height: 118.h),
          SizedBox(height: AppSpacing.md),
          _line(context, width: 80.w),
          SizedBox(height: AppSpacing.sm),
          _block(context, height: 112.h),
        ],
      ),
    );
  }

  Widget _line(BuildContext context, {required double width}) {
    return _block(context, width: width, height: 14.h);
  }

  Widget _pill(BuildContext context, {required double width}) {
    return _block(context, width: width, height: 36.h, radius: 30.r);
  }

  Widget _block(
    BuildContext context, {
    double? width,
    required double height,
    double? radius,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius ?? AppSpacing.nm),
      ),
    );
  }
}
