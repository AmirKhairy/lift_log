import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class MachineDetailsTutorialCard extends StatelessWidget {
  const MachineDetailsTutorialCard({
    super.key,
    required this.tutorial,
    required this.onTap,
    this.error,
  });

  final TutorialVideosModel? tutorial;
  final String? error;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return AppCard(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: AppText(
          'videos_error',
          color: context.appColors.subtitle,
          fontSize: 14.sp,
        ),
      );
    }

    if (tutorial == null) {
      return AppCard(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: AppText(
          'no_tutorial_videos',
          color: context.appColors.subtitle,
          fontSize: 14.sp,
        ),
      );
    }

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(AppSpacing.sm.w),
      child: Row(
        children: [
          AppCachedNetworkImage(
            imageUrl: tutorial!.thumbnailUrl ?? '',
            width: 96.w,
            height: 64.h,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  tutorial!.title ?? 'tutorial_videos',
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xs),
                AppText(
                  'machine_tutorial',
                  color: context.appColors.subtitle,
                  fontSize: 12.sp,
                ),
              ],
            ),
          ),
          Icon(
            Icons.play_circle_outline,
            color: context.theme.colorScheme.primary,
            size: 28.sp,
          ),
        ],
      ),
    );
  }
}
