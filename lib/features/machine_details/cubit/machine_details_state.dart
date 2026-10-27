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

sealed class MachineDetailsContentState extends MachineDetailsState {
  const MachineDetailsContentState({
    required this.machine,
    this.tutorial,
    this.history = const [],
    this.tutorialError,
    this.historyError,
  });

  final MachineModel machine;
  final TutorialVideosModel? tutorial;
  final List<MachineWorkoutHistoryItem> history;
  final String? tutorialError;
  final String? historyError;

  @override
  List<Object?> get props => [
    machine,
    tutorial,
    history,
    tutorialError,
    historyError,
  ];
}

final class MachineDetailsLoaded extends MachineDetailsContentState {
  const MachineDetailsLoaded({
    required super.machine,
    super.tutorial,
    super.history,
    super.tutorialError,
    super.historyError,
  });
}

final class MachineDetailsDeleting extends MachineDetailsContentState {
  const MachineDetailsDeleting({
    required super.machine,
    super.tutorial,
    super.history,
    super.tutorialError,
    super.historyError,
  });
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
