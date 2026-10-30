import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:shimmer/shimmer.dart';

class BodyProgressLoadingShimmer extends StatelessWidget {
  const BodyProgressLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.colorScheme.surfaceContainerHighest,
      highlightColor: context.theme.colorScheme.surface,
      child: ListView(
        padding: AppPadding.screen,
        children: [
          Row(
            children: [
              Expanded(child: _cardPlaceholder(context)),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: _cardPlaceholder(context)),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          _barPlaceholder(context, height: 52.h),
          SizedBox(height: AppSpacing.md),
          _cardPlaceholder(context, height: 230),
          SizedBox(height: AppSpacing.md),
          _cardPlaceholder(context, height: 140),
          SizedBox(height: AppSpacing.md),
          _cardPlaceholder(context, height: 180),
        ],
      ),
    );
  }

  Widget _cardPlaceholder(BuildContext context, {double height = 92}) {
    return AppCard(
      child: SizedBox(
        height: height.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _barPlaceholder(context, width: 120.w, height: 16.h),
            SizedBox(height: AppSpacing.md),
            _barPlaceholder(context, height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _barPlaceholder(
    BuildContext context, {
    double? width,
    required double height,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
