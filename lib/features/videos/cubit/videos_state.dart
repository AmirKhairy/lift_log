import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/utils/target_muscle.dart';

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
  const VideosLoading(this.muscleGroup, [this.targetMuscle]);

  final MuscleGroup muscleGroup;
  final TargetMuscle? targetMuscle;

  @override
  MuscleGroup get selectedMuscleGroup => muscleGroup;

  @override
  List<Object?> get props => [muscleGroup, targetMuscle];
}

final class VideosLoaded extends VideosState {
  const VideosLoaded({
    required this.muscleGroup,
    this.targetMuscle,
    required this.videos,
  });

  final MuscleGroup muscleGroup;
  final TargetMuscle? targetMuscle;
  final List<TutorialVideosModel> videos;

  @override
  MuscleGroup get selectedMuscleGroup => muscleGroup;

  @override
  List<Object?> get props => [muscleGroup, targetMuscle, videos];
}

final class VideosError extends VideosState {
  const VideosError(
    this.message, {
    required this.muscleGroup,
    this.targetMuscle,
  });

  final String message;
  final MuscleGroup muscleGroup;
  final TargetMuscle? targetMuscle;

  @override
  MuscleGroup get selectedMuscleGroup => muscleGroup;

  @override
  List<Object?> get props => [message, muscleGroup, targetMuscle];
}
