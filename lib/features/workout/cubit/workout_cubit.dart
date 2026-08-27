import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/services/api_services/machines_service.dart';
import 'package:lift_log/core/services/api_services/workout_service.dart';

import 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit({MachineModel? initialMachine, WorkoutService? workoutService})
    : _workoutService = workoutService ?? WorkoutService.instance,
      super(
        WorkoutEditing(
          WorkoutDraft(
            machines: initialMachine == null
                ? const []
                : [workoutMachineDraft(initialMachine)],
          ),
          isLoadingMachines: true,
        ),
      );

  final WorkoutService _workoutService;
  final MachinesService _machinesService = MachinesService.instance;

  WorkoutDraft get draft => switch (state) {
    WorkoutEditing(:final draft) => draft,
    WorkoutSaving(:final draft) => draft,
    WorkoutError(:final draft) => draft,
    WorkoutSaved() => WorkoutDraft(),
  };

  List<MachineModel> get availableMachines => switch (state) {
    WorkoutEditing(:final availableMachines) => availableMachines,
    WorkoutSaving(:final availableMachines) => availableMachines,
    WorkoutError(:final availableMachines) => availableMachines,
    WorkoutSaved() => const [],
  };

  List<MachineModel> get selectableMachines {
    final selectedIds = draft.machines
        .map((machineLog) => machineLog.machine.id)
        .toSet();

    return availableMachines
        .where((machine) => !selectedIds.contains(machine.id))
        .toList();
  }

  bool get isLoadingMachines =>
      state is WorkoutEditing && (state as WorkoutEditing).isLoadingMachines;

  Future<void> loadMachines() async {
    try {
      await _machinesService.getMachines();
      final machines = _machinesService.machines ?? const <MachineModel>[];
      _emitEditing(
        draft,
        availableMachines: machines,
        isLoadingMachines: false,
        clearMachinesError: true,
      );
    } catch (error) {
      _emitEditing(
        draft,
        isLoadingMachines: false,
        machinesError: error.toString(),
      );
    }
  }

  void updatePerformedAt(DateTime value) {
    _emitDraft(draft.copyWith(performedAt: value));
  }

  void updatePerformedDateTime(DateTime date, TimeOfDay time) {
    updatePerformedAt(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  void updateNotes(String value) {
    _emitDraft(draft.copyWith(notes: value));
  }

  void addMachine(MachineModel machine) {
    if (draft.machines.any((item) => item.machine.id == machine.id)) return;

    _emitEditing(
      draft.copyWith(
        machines: [...draft.machines, workoutMachineDraft(machine)],
      ),
    );
  }

  void removeMachine(int index) {
    final machines = [...draft.machines]..removeAt(index);
    _emitDraft(draft.copyWith(machines: machines));
  }

  void updateMachineNotes(int index, String notes) {
    final machines = [...draft.machines];
    machines[index] = machines[index].copyWith(notes: notes);
    _emitDraft(draft.copyWith(machines: machines));
  }

  void addSet(int machineIndex) {
    final machines = [...draft.machines];
    final machineLog = machines[machineIndex];
    machines[machineIndex] = machineLog.copyWith(
      sets: [
        ...machineLog.sets,
        WorkoutSetDraft(setNumber: machineLog.sets.length + 1),
      ],
    );
    _emitDraft(draft.copyWith(machines: machines));
  }

  void removeSet(int machineIndex, int setIndex) {
    final machines = [...draft.machines];
    final machineLog = machines[machineIndex];
    if (machineLog.sets.length == 1) return;

    final sets = [...machineLog.sets]..removeAt(setIndex);
    machines[machineIndex] = machineLog.copyWith(
      sets: [
        for (var index = 0; index < sets.length; index++)
          sets[index].copyWith(setNumber: index + 1),
      ],
    );
    _emitDraft(draft.copyWith(machines: machines));
  }

  void updateSet({
    required int machineIndex,
    required int setIndex,
    double? weight,
    int? reps,
  }) {
    final machines = [...draft.machines];
    final machineLog = machines[machineIndex];
    final sets = [...machineLog.sets];
    sets[setIndex] = sets[setIndex].copyWith(weight: weight, reps: reps);
    machines[machineIndex] = machineLog.copyWith(sets: sets);
    _emitDraft(draft.copyWith(machines: machines));
  }

  Future<void> save() async {
    final error = draft.validate();
    if (error != null) {
      _emitEditing(draft, error: error);
      return;
    }

    emit(WorkoutSaving(draft, availableMachines: availableMachines));
    try {
      await _workoutService.saveWorkout(draft);

      emit(const WorkoutSaved());
    } catch (error) {
      emit(
        WorkoutError(
          error.toString(),
          draft,
          availableMachines: availableMachines,
        ),
      );
    }
  }

  void _emitDraft(WorkoutDraft nextDraft) {
    _emitEditing(nextDraft);
  }

  void _emitEditing(
    WorkoutDraft nextDraft, {
    List<MachineModel>? availableMachines,
    bool? isLoadingMachines,
    String? machinesError,
    String? error,
    bool clearError = false,
    bool clearMachinesError = false,
  }) {
    final current = state is WorkoutEditing ? state as WorkoutEditing : null;
    emit(
      WorkoutEditing(
        nextDraft,
        error: clearError ? null : error ?? current?.error,
        availableMachines:
            availableMachines ?? current?.availableMachines ?? const [],
        isLoadingMachines:
            isLoadingMachines ?? current?.isLoadingMachines ?? false,
        machinesError: clearMachinesError
            ? null
            : machinesError ?? current?.machinesError,
      ),
    );
  }
}
