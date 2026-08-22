import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';
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
  });

  final List<TutorialVideosModel> videos;
  final TutorialVideosModel? selectedVideo;
  final bool isLoading;
  final ValueChanged<TutorialVideosModel> onSelected;
  final ValueChanged<TutorialVideosModel> onPlay;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _TutorialVideosLoading();
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

    return SizedBox(
      height: 118.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final video = videos[index];
          final isSelected = selectedVideo?.id == video.id;

          return _TutorialVideoTile(
            video: video,
            isSelected: isSelected,
            onTap: () => onSelected(video),
            onPlay: () => onPlay(video),
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
    required this.onTap,
    required this.onPlay,
  });

  final TutorialVideosModel video;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppSpacing.nm),
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onPlay,
        borderRadius: BorderRadius.circular(AppSpacing.nm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 190.w,
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
                  AppCachedNetworkImage(
                    imageUrl: video.thumbnailUrl ?? '',
                    width: 70.w,
                    height: 86.h,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
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
}

class _TutorialVideosLoading extends StatelessWidget {
  const _TutorialVideosLoading();

  @override
  Widget build(BuildContext context) {
    final baseColor = context.theme.colorScheme.surfaceContainerHighest;
    final highlightColor = context.theme.colorScheme.surface;

    return SizedBox(
      height: 118.h,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
          itemBuilder: (_, _) {
            return Container(
              width: 190.w,
              padding: EdgeInsets.all(AppSpacing.sm.w),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.nm),
              ),
            );
          },
        ),
      ),
    );
  }
}
