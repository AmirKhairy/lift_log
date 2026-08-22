import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/utils/app_enums.dart';

sealed class VideosState extends Equatable {
  const VideosState();

  MuscleGroup get selectedMuscleGroup => MuscleGroup.values.first;

  @override
  List<Object?> get props => [];
}

final class VideosInitial extends VideosState {
  const VideosInitial();
}

final class VideosLoading extends VideosState {
  const VideosLoading(this.muscleGroup);

  final MuscleGroup muscleGroup;

  @override
  MuscleGroup get selectedMuscleGroup => muscleGroup;

  @override
  List<Object?> get props => [muscleGroup];
}

final class VideosLoaded extends VideosState {
  const VideosLoaded({required this.muscleGroup, required this.videos});

  final MuscleGroup muscleGroup;
  final List<TutorialVideosModel> videos;

  @override
  MuscleGroup get selectedMuscleGroup => muscleGroup;

  @override
  List<Object?> get props => [muscleGroup, videos];
}

final class VideosError extends VideosState {
  const VideosError(this.message, {required this.muscleGroup});

  final String message;
  final MuscleGroup muscleGroup;

  @override
  MuscleGroup get selectedMuscleGroup => muscleGroup;

  @override
  List<Object?> get props => [message, muscleGroup];
}
