import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/services/api_services/machines_service.dart';
import 'package:lift_log/core/services/api_services/workout_service.dart';
import 'package:lift_log/core/services/api_services/routine_service.dart';
import 'package:lift_log/core/services/workout_draft_storage.dart';

import 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit({
    MachineModel? initialMachine,
    WorkoutService? workoutService,
    RoutineService? routineService,
  }) : _initialMachine = initialMachine,
       _workoutService = workoutService ?? WorkoutService.instance,
       _routineService = routineService ?? RoutineService.instance,
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
  final RoutineService _routineService;
  final WorkoutDraftStorage _draftStorage = WorkoutDraftStorage.instance;
  final MachineModel? _initialMachine;
  String? _appliedRoutineId;
  bool _isEditingRoutine = false;
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

  List<RoutineModel> get routines => switch (state) {
    WorkoutEditing(:final routines) => routines,
    WorkoutSaving(:final routines) => routines,
    WorkoutError(:final routines) => routines,
    WorkoutSaved() => const [],
  };

  String? get appliedRoutineName {
    final routineId = _appliedRoutineId;
    if (routineId == null) return null;

    for (final routine in routines) {
      if (routine.id == routineId) return routine.name;
    }
    return null;
  }

  bool get shouldShowRoutineSave =>
      _appliedRoutineId == null || _isEditingRoutine;

  bool get isEditingRoutine => _isEditingRoutine;

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
    final cachedDraft = await _draftStorage.load();
    var restoredDraft = cachedDraft ?? draft;
    if (_initialMachine != null &&
        !restoredDraft.machines.any(
          (item) => item.machine.id == _initialMachine.id,
        )) {
      restoredDraft = restoredDraft.copyWith(
        machines: [
          ...restoredDraft.machines,
          workoutMachineDraft(_initialMachine),
        ],
      );
    }
    if (cachedDraft != null || _initialMachine != null) {
      _emitEditing(restoredDraft);
    }

    try {
      await Future.wait([_machinesService.getMachines(), _loadRoutines()]);
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

  Future<void> _loadRoutines() async {
    try {
      final loaded = await _routineService.getRoutines();
      _emitEditing(draft, routines: loaded);
    } catch (_) {}
  }

  void applyRoutine(RoutineModel routine, {bool editing = false}) {
    _appliedRoutineId = routine.id;
    _isEditingRoutine = editing;
    _emitDraft(draft.copyWith(machines: routine.exercises));
  }

  Future<bool> saveRoutine(String name) async {
    final error = draft.validate();
    if (error != null) {
      _emitEditing(draft, error: error);
      return false;
    }
    await _routineService.saveRoutine(name, draft, id: _appliedRoutineId);
    final loaded = await _routineService.getRoutines();
    _emitEditing(draft, routines: loaded, clearError: true);
    return true;
  }

  Future<void> deleteRoutine(String routineId) async {
    await _routineService.deleteRoutine(routineId);
    if (_appliedRoutineId == routineId) _appliedRoutineId = null;
    final loaded = await _routineService.getRoutines();
    _emitEditing(draft, routines: loaded, clearError: true);
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

    _emitDraft(
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
    int? durationSeconds,
  }) {
    final parsedWeight = weight?.isFinite == true ? weight : null;
    final machines = [...draft.machines];
    final machineLog = machines[machineIndex];
    final sets = [...machineLog.sets];
    sets[setIndex] = WorkoutSetDraft(
      setNumber: sets[setIndex].setNumber,
      weight: parsedWeight,
      reps: reps,
      durationSeconds: durationSeconds,
    );
    machines[machineIndex] = machineLog.copyWith(sets: sets);
    _emitDraft(draft.copyWith(machines: machines));
  }

  Future<void> save() async {
    final error = draft.validate();
    if (error != null) {
      _emitEditing(draft, error: error);
      return;
    }

    emit(
      WorkoutSaving(
        draft,
        availableMachines: availableMachines,
        routines: routines,
      ),
    );
    try {
      await _workoutService.saveWorkout(draft);
      if (_appliedRoutineId != null) {
        final routine = routines.firstWhere(
          (item) => item.id == _appliedRoutineId,
        );
        await _routineService.saveRoutine(routine.name, draft, id: routine.id);
      }

      await _draftStorage.clear();

      emit(const WorkoutSaved());
    } catch (error) {
      emit(
        WorkoutError(
          error.toString(),
          draft,
          availableMachines: availableMachines,
          routines: routines,
        ),
      );
    }
  }

  void _emitDraft(WorkoutDraft nextDraft) {
    _emitEditing(nextDraft, clearError: true);
    _persistDraft(nextDraft);
  }

  void _persistDraft(WorkoutDraft nextDraft) {
    unawaited(_draftStorage.save(nextDraft));
  }

  void _emitEditing(
    WorkoutDraft nextDraft, {
    List<MachineModel>? availableMachines,
    bool? isLoadingMachines,
    String? machinesError,
    String? error,
    List<RoutineModel>? routines,
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
        routines: routines ?? current?.routines ?? const [],
      ),
    );
  }
}
