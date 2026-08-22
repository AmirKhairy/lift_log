import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_labeled_text_field.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/muscle_group_selector.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/tutorial_video_selector.dart';
import 'package:lift_log/features/videos/presentation/widgets/videos_loading.dart'
    as loading_widget;

import '../../cubit/videos_cubit.dart';
import '../../cubit/videos_state.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _VideosView();
  }
}

class _VideosView extends StatelessWidget {
  const _VideosView();

  void _playVideo(BuildContext context, TutorialVideosModel video) {
    if (video.videoUrl?.trim().isEmpty ?? true) {
      AppSnackbar.error(message: 'video_link_not_available', context: context);
      return;
    }

    context.push(AppRoutes.tutorialVideoPlayer, extra: video);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideosCubit, VideosState>(
      listener: (context, state) {
        if (state is VideosError) {
          AppSnackbar.error(message: 'videos_error', context: context);
        }
      },
      builder: (context, state) {
        final selectedMuscleGroup = state.selectedMuscleGroup;
        final videos = state is VideosLoaded
            ? state.videos
            : List<TutorialVideosModel>.empty();
        final isLoading = state is VideosLoading || state is VideosInitial;

        return AppScaffold(
          title: 'videos',
          centerTitle: false,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppStaggeredAnimation(
                index: 0,
                child: LabeledTextField(
                  label: 'muscle_group',
                  child: MuscleGroupSelector(
                    selectedMuscleGroup: selectedMuscleGroup,
                    onSelected: context.read<VideosCubit>().selectMuscleGroup,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Expanded(
                child: AppStaggeredAnimation(
                  index: 1,
                  child: state is VideosError
                      ? Center(child: AppText('videos_error'))
                      : isLoading
                      ? const loading_widget.VideosLoading()
                      : TutorialVideoSelector(
                          videos: videos,
                          selectedVideo: null,
                          isLoading: false,
                          isVertical: true,
                          onSelected: (video) => _playVideo(context, video),
                          onPlay: (video) => _playVideo(context, video),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
