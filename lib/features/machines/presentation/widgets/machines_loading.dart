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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextPlaceholder(
                    context,
                    labelWidth: 100.w,
                    valueWidth: 120.w,
                  ),

                  SizedBox(height: AppSpacing.sm),

                  _buildTextPlaceholder(
                    context,
                    labelWidth: 110.w,
                    valueWidth: 90.w,
                  ),
                ],
              ),
            ),

            SizedBox(width: AppSpacing.sm),

            Container(
              width: 120.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
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
        Flexible(
          child: Container(
            width: valueWidth,
            height: 20.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
      ],
    );
  }
}
