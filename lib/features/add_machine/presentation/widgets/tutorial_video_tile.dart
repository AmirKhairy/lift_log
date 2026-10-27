import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class TutorialVideoTile extends StatelessWidget {
  const TutorialVideoTile({
    super.key,
    required this.video,
    required this.isSelected,
    required this.isVertical,
    required this.onTap,
    required this.onPlay,
  });

  final TutorialVideosModel video;
  final bool isSelected;
  final bool isVertical;
  final VoidCallback onTap;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppSpacing.nm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.nm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: isVertical ? double.infinity : 190.w,
          height: isVertical ? 142.h : null,
          padding: EdgeInsets.all(AppSpacing.sm.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.nm),
            border: Border.all(
              color: isSelected
                  ? context.theme.colorScheme.primary
                  : context.appColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Hero(
                    tag: _videoHeroTag(video),
                    child: AppCachedNetworkImage(
                      imageUrl: video.thumbnailUrl ?? '',
                      width: isVertical ? 104.w : 70.w,
                      height: isVertical ? 118.h : 86.h,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                  ),
                  GestureDetector(
                    onTap: onPlay,
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.primary.withValues(
                          alpha: 0.8,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: context.theme.colorScheme.onSurface,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppText(
                      video.title ?? '',
                      color: context.theme.colorScheme.onSurface,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Expanded(
                      child: AppText(
                        video.description ?? '',
                        color: context.appColors.subtitle,
                        fontSize: 11.sp,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _videoHeroTag(TutorialVideosModel item) =>
      'tutorial-video-${item.id ?? item.videoUrl ?? item.title}';
}
