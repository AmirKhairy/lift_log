import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/models/workout_models.dart';

sealed class MachineDetailsState extends Equatable {
  const MachineDetailsState();

  @override
  List<Object?> get props => [];
}

final class MachineDetailsInitial extends MachineDetailsState {
  const MachineDetailsInitial();
}

final class MachineDetailsLoading extends MachineDetailsState {
  const MachineDetailsLoading();
}

final class MachineDetailsLoaded extends MachineDetailsState {
  const MachineDetailsLoaded({
    required this.machine,
    this.tutorial,
    this.history = const [],
    this.tutorialError,
    this.historyError,
    this.isDeleting = false,
  });

  final MachineModel machine;
  final TutorialVideosModel? tutorial;
  final List<MachineWorkoutHistoryItem> history;
  final String? tutorialError;
  final String? historyError;
  final bool isDeleting;

  MachineDetailsLoaded copyWith({
    MachineModel? machine,
    TutorialVideosModel? tutorial,
    List<MachineWorkoutHistoryItem>? history,
    String? tutorialError,
    String? historyError,
    bool clearTutorial = false,
    bool clearTutorialError = false,
    bool clearHistoryError = false,
    bool? isDeleting,
  }) {
    return MachineDetailsLoaded(
      machine: machine ?? this.machine,
      tutorial: clearTutorial ? null : tutorial ?? this.tutorial,
      history: history ?? this.history,
      tutorialError: clearTutorialError
          ? null
          : tutorialError ?? this.tutorialError,
      historyError: clearHistoryError
          ? null
          : historyError ?? this.historyError,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object?> get props => [
    machine,
    tutorial,
    history,
    tutorialError,
    historyError,
    isDeleting,
  ];
}

final class MachineDetailsError extends MachineDetailsState {
  const MachineDetailsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class MachineDetailsDeleted extends MachineDetailsState {
  const MachineDetailsDeleted();
}
