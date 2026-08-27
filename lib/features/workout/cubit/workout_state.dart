import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/workout_models.dart';

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
  });

  final WorkoutDraft draft;
  final String? error;
  final List<MachineModel> availableMachines;
  final bool isLoadingMachines;
  final String? machinesError;

  WorkoutEditing copyWith({
    WorkoutDraft? draft,
    String? error,
    bool clearError = false,
    List<MachineModel>? availableMachines,
    bool? isLoadingMachines,
    String? machinesError,
    bool clearMachinesError = false,
  }) {
    return WorkoutEditing(
      draft ?? this.draft,
      error: clearError ? null : error ?? this.error,
      availableMachines: availableMachines ?? this.availableMachines,
      isLoadingMachines: isLoadingMachines ?? this.isLoadingMachines,
      machinesError: clearMachinesError
          ? null
          : machinesError ?? this.machinesError,
    );
  }

  @override
  List<Object?> get props => [
    draft,
    error,
    availableMachines,
    isLoadingMachines,
    machinesError,
  ];
}

final class WorkoutSaving extends WorkoutState {
  const WorkoutSaving(this.draft, {this.availableMachines = const []});

  final WorkoutDraft draft;
  final List<MachineModel> availableMachines;

  @override
  List<Object?> get props => [draft, availableMachines];
}

final class WorkoutSaved extends WorkoutState {
  const WorkoutSaved();
}

final class WorkoutError extends WorkoutState {
  const WorkoutError(
    this.message,
    this.draft, {
    this.availableMachines = const [],
  });

  final String message;
  final WorkoutDraft draft;
  final List<MachineModel> availableMachines;

  @override
  List<Object?> get props => [message, draft, availableMachines];
}

extension WorkoutDraftValidation on WorkoutDraft {
  String? validate() {
    if (machines.isEmpty) return 'workout_empty_machines';

    for (final machineLog in machines) {
      if (machineLog.machine.id == null) return 'workout_invalid_machine';
      if (machineLog.sets.isEmpty) return 'workout_empty_sets';

      for (final set in machineLog.sets) {
        if (set.weight == null || set.weight! <= 0) {
          return 'workout_invalid_weight';
        }
        if (set.reps == null || set.reps! <= 0) {
          return 'workout_invalid_reps';
        }
      }
    }

    return null;
  }
}

WorkoutMachineDraft workoutMachineDraft(MachineModel machine) {
  return WorkoutMachineDraft(machine: machine);
}
