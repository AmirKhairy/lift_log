import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:shimmer/shimmer.dart';

class TutorialVideoSelector extends StatelessWidget {
  const TutorialVideoSelector({
    super.key,
    required this.videos,
    required this.selectedVideo,
    required this.isLoading,
    required this.onSelected,
    required this.onPlay,
    this.isVertical = false,
    this.isNestedInScrollView = false,
  });

  final List<TutorialVideosModel> videos;
  final TutorialVideosModel? selectedVideo;
  final bool isLoading;
  final ValueChanged<TutorialVideosModel> onSelected;
  final ValueChanged<TutorialVideosModel> onPlay;
  final bool isVertical;
  final bool isNestedInScrollView;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _TutorialVideosLoading(isVertical: isVertical);
    }

    if (videos.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.md.w),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.nm),
        ),
        child: AppText(
          'no_tutorial_videos',
          color: context.appColors.subtitle,
          fontSize: 14.sp,
        ),
      );
    }

    return isVertical
        ? ListView.separated(
            padding: EdgeInsets.only(bottom: AppSpacing.md.h),
            shrinkWrap: isNestedInScrollView,
            physics: isNestedInScrollView
                ? const NeverScrollableScrollPhysics()
                : null,
            itemCount: videos.length,
            separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md.h),
            itemBuilder: (context, index) {
              final video = videos[index];

              return AppStaggeredAnimation(
                index: index,
                child: _TutorialVideoTile(
                  video: video,
                  isSelected: selectedVideo?.id == video.id,
                  isVertical: true,
                  onTap: () => onSelected(video),
                  onPlay: () => onPlay(video),
                ),
              );
            },
          )
        : SizedBox(
            height: 118.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final video = videos[index];
                final isSelected = selectedVideo?.id == video.id;

                return AppStaggeredAnimation(
                  index: index,
                  child: _TutorialVideoTile(
                    video: video,
                    isSelected: isSelected,
                    isVertical: false,
                    onTap: () => onSelected(video),
                    onPlay: () => onPlay(video),
                  ),
                );
              },
            ),
          );
  }
}

class _TutorialVideoTile extends StatelessWidget {
  const _TutorialVideoTile({
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppText(
                        video.title ?? '',
                        color: context.theme.colorScheme.onSurface,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Expanded(
                      child: AppText(
                        video.description ?? '',
                        color: context.appColors.subtitle,
                        fontSize: 11.sp,
                        maxLines: 2,
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

class _TutorialVideosLoading extends StatelessWidget {
  const _TutorialVideosLoading({required this.isVertical});

  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    final baseColor = context.theme.colorScheme.surfaceContainerHighest;
    final highlightColor = context.theme.colorScheme.surface;

    final shimmer = Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        padding: isVertical
            ? EdgeInsets.only(bottom: AppSpacing.md.h)
            : EdgeInsets.zero,
        scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (_, _) => SizedBox(
          width: isVertical ? 0 : AppSpacing.sm,
          height: isVertical ? AppSpacing.md.h : 0,
        ),
        itemBuilder: (_, _) {
          return Container(
            width: isVertical ? double.infinity : 190.w,
            height: isVertical ? 142.h : null,
            padding: EdgeInsets.all(AppSpacing.sm.w),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.nm),
            ),
          );
        },
      ),
    );

    return isVertical ? shimmer : SizedBox(height: 118.h, child: shimmer);
  }
}
