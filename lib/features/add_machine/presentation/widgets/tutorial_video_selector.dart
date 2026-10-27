import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/tutorial_video_tile.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/tutorial_videos_loading.dart';

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
      return TutorialVideosLoading(isVertical: isVertical);
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
                child: TutorialVideoTile(
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
                  child: TutorialVideoTile(
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
