import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/services/api_services/tutorial_videos_service.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';

import 'videos_state.dart';

class VideosCubit extends Cubit<VideosState> {
  VideosCubit({TutorialVideosService? service})
    : _service = service ?? TutorialVideosService.instance,
      super(const VideosInitial());

  final TutorialVideosService _service;
  MuscleGroup _selectedMuscleGroup = MuscleGroup.values.first;
  bool _hasLoaded = false;
  Future<void>? _loadingFuture;

  Future<void> loadIfNeeded() {
    if (_hasLoaded) {
      return Future.value();
    }

    if (_loadingFuture != null) {
      return _loadingFuture!;
    }

    final future = _loadData(
      muscleGroup: _selectedMuscleGroup,
      forceRefresh: false,
    );
    _loadingFuture = future;
    return future.whenComplete(() => _loadingFuture = null);
  }

  Future<void> refresh() async {
    await _loadData(muscleGroup: _selectedMuscleGroup, forceRefresh: true);
  }

  Future<void> selectMuscleGroup(MuscleGroup muscleGroup) async {
    _selectedMuscleGroup = muscleGroup;
    _hasLoaded = false;
    await _loadData(muscleGroup: muscleGroup, forceRefresh: false);
  }

  Future<void> _loadData({
    required MuscleGroup muscleGroup,
    required bool forceRefresh,
  }) async {
    emit(VideosLoading(muscleGroup));

    try {
      final videos = await _service.getByMuscleGroup(
        muscleGroup,
        forceRefresh: forceRefresh,
      );

      _hasLoaded = true;
      emit(VideosLoaded(muscleGroup: muscleGroup, videos: videos));
    } catch (e, s) {
      _hasLoaded = false;
      debugPrintStack(stackTrace: s);
      emit(VideosError(e.toString(), muscleGroup: muscleGroup));
    }
  }

  void playVideo(BuildContext context, TutorialVideosModel video) {
    if (video.videoUrl?.trim().isEmpty ?? true) {
      AppSnackbar.error(message: 'video_link_not_available', context: context);
      return;
    }

    context.push(
      AppRoutes.tutorialVideoPlayer,
      extra: {'video': video, 'relatedVideos': videosForVideo(context, video)},
    );
  }

  List<TutorialVideosModel> videosForVideo(
    BuildContext context,
    TutorialVideosModel video,
  ) {
    final state = context.read<VideosCubit>().state;
    return state is VideosLoaded ? state.videos : [video];
  }
}
