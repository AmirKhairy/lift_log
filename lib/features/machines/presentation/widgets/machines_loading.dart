import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:shimmer/shimmer.dart';

class MachineShimmer extends StatelessWidget {
  const MachineShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.theme.colorScheme.surfaceContainerHighest;
    final highlightColor = context.theme.colorScheme.surface;

    return Container(
      padding: AppPadding.xs,
      margin: AppPadding.xs,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        color: context.theme.colorScheme.surface,
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.sm),

            _buildTextPlaceholder(
              context,
              labelWidth: 110.w,
              valueWidth: 130.w,
            ),

            SizedBox(height: AppSpacing.sm),

            _buildTextPlaceholder(
              context,
              labelWidth: 120.w,
              valueWidth: 100.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextPlaceholder(
    BuildContext context, {
    required double labelWidth,
    required double valueWidth,
  }) {
    final color = context.theme.colorScheme.surfaceContainerHighest;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: labelWidth,
          height: 20.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Container(
          width: valueWidth,
          height: 20.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }
}
