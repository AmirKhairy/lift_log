import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/utils/app_enums.dart';

sealed class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

final class WorkoutEditing extends WorkoutState {
  const WorkoutEditing(
    this.draft, {
    this.error,
    this.availableMachines = const [],
    this.isLoadingMachines = false,
    this.machinesError,
    this.routines = const [],
    this.startedAt,
    this.endedAt,
    this.elapsed = Duration.zero,
    this.isPaused = false,
  });

  final WorkoutDraft draft;
  final String? error;
  final List<MachineModel> availableMachines;
  final bool isLoadingMachines;
  final String? machinesError;
  final List<RoutineModel> routines;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final Duration elapsed;
  final bool isPaused;

  @override
  List<Object?> get props => [
    draft,
    error,
    availableMachines,
    isLoadingMachines,
    machinesError,
    routines,
    startedAt,
    endedAt,
    elapsed,
    isPaused,
  ];
}

final class WorkoutSaving extends WorkoutState {
  const WorkoutSaving(
    this.draft, {
    this.availableMachines = const [],
    this.routines = const [],
    this.startedAt,
    this.endedAt,
    this.elapsed = Duration.zero,
    this.isPaused = false,
  });

  final WorkoutDraft draft;
  final List<MachineModel> availableMachines;
  final List<RoutineModel> routines;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final Duration elapsed;
  final bool isPaused;

  @override
  List<Object?> get props => [
    draft,
    availableMachines,
    routines,
    startedAt,
    endedAt,
    elapsed,
    isPaused,
  ];
}

final class WorkoutRoutineSaving extends WorkoutState {
  const WorkoutRoutineSaving(
    this.draft, {
    this.availableMachines = const [],
    this.routines = const [],
    this.startedAt,
    this.endedAt,
    this.elapsed = Duration.zero,
    this.isPaused = false,
  });

  final WorkoutDraft draft;
  final List<MachineModel> availableMachines;
  final List<RoutineModel> routines;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final Duration elapsed;
  final bool isPaused;

  @override
  List<Object?> get props => [
    draft,
    availableMachines,
    routines,
    startedAt,
    endedAt,
    elapsed,
    isPaused,
  ];
}

final class WorkoutSaved extends WorkoutState {
  const WorkoutSaved();
}

final class WorkoutError extends WorkoutState {
  const WorkoutError(
    this.message,
    this.draft, {
    this.availableMachines = const [],
    this.routines = const [],
    this.startedAt,
    this.endedAt,
    this.elapsed = Duration.zero,
    this.isPaused = false,
  });

  final String message;
  final WorkoutDraft draft;
  final List<MachineModel> availableMachines;
  final List<RoutineModel> routines;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final Duration elapsed;
  final bool isPaused;

  @override
  List<Object?> get props => [
    message,
    draft,
    availableMachines,
    routines,
    startedAt,
    endedAt,
    elapsed,
    isPaused,
  ];
}

extension WorkoutDraftValidation on WorkoutDraft {
  String? validate({bool requireTiming = true}) {
    if (requireTiming && startedAt == null) return 'workout_not_started';
    if (requireTiming && endedAt == null) return 'workout_not_finished';
    if (machines.isEmpty) return 'workout_empty_machines';

    for (final machineLog in machines) {
      if (machineLog.machine.id == null) return 'workout_invalid_machine';
      if (machineLog.sets.isEmpty) return 'workout_empty_sets';

      for (final set in machineLog.sets) {
        final type = machineLog.machine.exerciseType;
        if (type == ExerciseType.weightReps || type == ExerciseType.reps) {
          if (set.reps == null) return 'workout_reps_required';
          if (set.reps! <= 0) return 'workout_invalid_reps';
        }
        if (type == ExerciseType.weightReps) {
          if (set.weight == null) return 'workout_weight_required';
          if (!set.weight!.isFinite || set.weight! <= 0) {
            return 'workout_invalid_weight';
          }
        }
        if (type == ExerciseType.time &&
            (set.durationSeconds == null || set.durationSeconds! <= 0)) {
          return 'workout_duration_required';
        }
      }
    }

    return null;
  }
}

WorkoutMachineDraft workoutMachineDraft(MachineModel machine) {
  return WorkoutMachineDraft(machine: machine);
}
