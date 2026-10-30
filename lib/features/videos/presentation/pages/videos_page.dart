import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_labeled_text_field.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/utils/target_muscle.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/muscle_group_selector.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/target_muscle_selector.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/tutorial_video_selector.dart';
import 'package:lift_log/features/videos/presentation/widgets/videos_loading.dart'
    as loading_widget;

import '../../cubit/videos_cubit.dart';
import '../../cubit/videos_state.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

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
              SizedBox(height: AppSpacing.sm),
              AppStaggeredAnimation(
                index: 1,
                child: TargetMuscleSelector(
                  options: targetMusclesFor(selectedMuscleGroup),
                  selected: state is VideosLoaded
                      ? state.targetMuscle
                      : state is VideosLoading
                      ? state.targetMuscle
                      : state is VideosError
                      ? state.targetMuscle
                      : null,
                  showAll: true,
                  onSelected: context.read<VideosCubit>().selectTargetMuscle,
                  onAllSelected: () =>
                      context.read<VideosCubit>().selectTargetMuscle(null),
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
                          onSelected: (video) => context
                              .read<VideosCubit>()
                              .playVideo(context, video),
                          onPlay: (video) => context
                              .read<VideosCubit>()
                              .playVideo(context, video),
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
