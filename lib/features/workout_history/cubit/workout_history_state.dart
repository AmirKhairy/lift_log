import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/workout_models.dart';

sealed class WorkoutHistoryState extends Equatable {
  const WorkoutHistoryState();

  @override
  List<Object?> get props => [];
}

final class WorkoutHistoryInitial extends WorkoutHistoryState {
  const WorkoutHistoryInitial();
}

final class WorkoutHistoryLoading extends WorkoutHistoryState {
  const WorkoutHistoryLoading();
}

final class WorkoutHistoryLoaded extends WorkoutHistoryState {
  const WorkoutHistoryLoaded(this.sessions);

  final List<WorkoutSessionModel> sessions;

  @override
  List<Object?> get props => [sessions];
}

final class WorkoutHistoryError extends WorkoutHistoryState {
  const WorkoutHistoryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
