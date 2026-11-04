import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/services/api_services/machines_service.dart';
import 'package:lift_log/core/services/api_services/routine_service.dart';
import 'package:lift_log/core/services/api_services/workout_service.dart';
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
  Timer? _workoutTimer;
  DateTime? _runningSince;
  Duration _pausedElapsed = Duration.zero;

  WorkoutDraft get draft => switch (state) {
    WorkoutEditing(:final draft) => draft,
    WorkoutSaving(:final draft) => draft,
    WorkoutRoutineSaving(:final draft) => draft,
    WorkoutError(:final draft) => draft,
    WorkoutSaved() => WorkoutDraft(),
  };

  List<MachineModel> get availableMachines => switch (state) {
    WorkoutEditing(:final availableMachines) => availableMachines,
    WorkoutSaving(:final availableMachines) => availableMachines,
    WorkoutRoutineSaving(:final availableMachines) => availableMachines,
    WorkoutError(:final availableMachines) => availableMachines,
    WorkoutSaved() => const [],
  };

  List<RoutineModel> get routines => switch (state) {
    WorkoutEditing(:final routines) => routines,
    WorkoutSaving(:final routines) => routines,
    WorkoutRoutineSaving(:final routines) => routines,
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

  bool get shouldShowRoutineSave => _appliedRoutineId == null;

  bool get isEditingRoutine => _isEditingRoutine;

  DateTime? get startedAt => switch (state) {
    WorkoutEditing(:final startedAt) => startedAt,
    WorkoutSaving(:final startedAt) => startedAt,
    WorkoutRoutineSaving(:final startedAt) => startedAt,
    WorkoutError(:final startedAt) => startedAt,
    WorkoutSaved() => null,
  };

  DateTime? get endedAt => switch (state) {
    WorkoutEditing(:final endedAt) => endedAt,
    WorkoutSaving(:final endedAt) => endedAt,
    WorkoutRoutineSaving(:final endedAt) => endedAt,
    WorkoutError(:final endedAt) => endedAt,
    WorkoutSaved() => null,
  };

  Duration get elapsed => switch (state) {
    WorkoutEditing(:final elapsed) => elapsed,
    WorkoutSaving(:final elapsed) => elapsed,
    WorkoutRoutineSaving(:final elapsed) => elapsed,
    WorkoutError(:final elapsed) => elapsed,
    WorkoutSaved() => Duration.zero,
  };

  bool get isPaused => switch (state) {
    WorkoutEditing(:final isPaused) => isPaused,
    WorkoutSaving(:final isPaused) => isPaused,
    WorkoutRoutineSaving(:final isPaused) => isPaused,
    WorkoutError(:final isPaused) => isPaused,
    WorkoutSaved() => false,
  };

  bool get isWorkoutStarted => startedAt != null;
  bool get isWorkoutFinished => endedAt != null;

  void startWorkout() {
    if (isWorkoutStarted || draft.machines.isEmpty) return;
    final now = DateTime.now();
    _runningSince = now;
    _pausedElapsed = Duration.zero;
    _emitTiming(
      draft.copyWith(
        performedAt: now,
        startedAt: now,
        activeSince: now,
        elapsedSeconds: 0,
        isPaused: false,
      ),
      startedAt: now,
      elapsed: Duration.zero,
      isPaused: false,
    );
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _persistDraft(draft);
  }

  void pauseWorkout() {
    if (!isWorkoutStarted || isPaused || isWorkoutFinished) return;
    _pausedElapsed += DateTime.now().difference(_runningSince!);
    _runningSince = null;
    _workoutTimer?.cancel();
    final pausedDraft = draft.copyWith(
      clearActiveSince: true,
      elapsedSeconds: _pausedElapsed.inSeconds,
      isPaused: true,
    );
    _emitTiming(pausedDraft, elapsed: _pausedElapsed, isPaused: true);
    _persistDraft(pausedDraft);
  }

  void resumeWorkout() {
    if (!isWorkoutStarted || !isPaused || isWorkoutFinished) return;
    _runningSince = DateTime.now();
    final resumedDraft = draft.copyWith(
      activeSince: _runningSince,
      isPaused: false,
    );
    _emitTiming(resumedDraft, elapsed: _pausedElapsed, isPaused: false);
    _persistDraft(resumedDraft);
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void finishWorkout() {
    if (!isWorkoutStarted || isWorkoutFinished) return;
    if (!isPaused) {
      _pausedElapsed += DateTime.now().difference(_runningSince!);
    }
    _runningSince = null;
    _workoutTimer?.cancel();
    final now = DateTime.now();
    final finishedDraft = draft.copyWith(
      endedAt: now,
      clearActiveSince: true,
      elapsedSeconds: _pausedElapsed.inSeconds,
      isPaused: true,
    );
    _emitTiming(
      finishedDraft,
      endedAt: now,
      elapsed: _pausedElapsed,
      isPaused: true,
    );
    _persistDraft(finishedDraft);
  }

  void resetWorkoutTimer() {
    _workoutTimer?.cancel();
    _runningSince = null;
    _pausedElapsed = Duration.zero;
    final resetDraft = draft.copyWith(
      performedAt: DateTime.now(),
      clearStartedAt: true,
      clearEndedAt: true,
      clearActiveSince: true,
      elapsedSeconds: 0,
      isPaused: false,
    );
    _emitEditing(resetDraft, clearError: true, clearTiming: true);
    _persistDraft(resetDraft);
  }

  void continueWorkout() {
    if (!isWorkoutFinished || startedAt == null) return;
    final now = DateTime.now();
    _runningSince = now;
    final continuedDraft = draft.copyWith(
      clearEndedAt: true,
      activeSince: now,
      isPaused: false,
    );
    _emitTiming(
      continuedDraft,
      startedAt: startedAt,
      elapsed: _pausedElapsed,
      isPaused: false,
    );
    _persistDraft(continuedDraft);
    _workoutTimer?.cancel();
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_runningSince == null || isSavingRoutine) return;
    _emitTiming(
      draft,
      elapsed: _pausedElapsed + DateTime.now().difference(_runningSince!),
      isPaused: false,
    );
  }

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

  bool get isSavingRoutine => state is WorkoutRoutineSaving;

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
    _restoreWorkoutTiming(restoredDraft);

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

  void _restoreWorkoutTiming(WorkoutDraft restoredDraft) {
    if (restoredDraft.startedAt == null) return;

    _pausedElapsed = Duration(seconds: restoredDraft.elapsedSeconds);
    if (restoredDraft.endedAt != null || restoredDraft.isPaused) {
      _emitTiming(
        restoredDraft,
        startedAt: restoredDraft.startedAt,
        endedAt: restoredDraft.endedAt,
        elapsed: _pausedElapsed,
        isPaused: true,
      );
      return;
    }

    _runningSince = restoredDraft.activeSince ?? restoredDraft.startedAt;
    _emitTiming(
      restoredDraft,
      startedAt: restoredDraft.startedAt,
      elapsed: _pausedElapsed + DateTime.now().difference(_runningSince!),
      isPaused: false,
    );
    _workoutTimer?.cancel();
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
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
    final error = draft.validate(requireTiming: false);
    if (error != null) {
      _emitEditing(draft, error: error);
      return false;
    }

    final routineDraft = draft;
    final machines = availableMachines;
    final savedRoutines = routines;
    final savedStartedAt = startedAt;
    final savedEndedAt = endedAt;
    final savedElapsed = elapsed;
    final savedIsPaused = isPaused;
    emit(
      WorkoutRoutineSaving(
        routineDraft,
        availableMachines: machines,
        routines: savedRoutines,
        startedAt: savedStartedAt,
        endedAt: savedEndedAt,
        elapsed: savedElapsed,
        isPaused: savedIsPaused,
      ),
    );

    try {
      final savedRoutineId = await _routineService.saveRoutine(
        name,
        routineDraft,
        id: _appliedRoutineId,
      );
      final loaded = await _routineService.getRoutines();
      _appliedRoutineId = savedRoutineId;
      _isEditingRoutine = false;
      _emitEditing(
        routineDraft,
        availableMachines: machines,
        routines: loaded,
        clearError: true,
        startedAt: savedStartedAt,
        endedAt: savedEndedAt,
        elapsed: savedElapsed,
        isPaused: savedIsPaused,
      );
      return true;
    } catch (_) {
      _emitEditing(
        routineDraft,
        availableMachines: machines,
        routines: savedRoutines,
        startedAt: savedStartedAt,
        endedAt: savedEndedAt,
        elapsed: savedElapsed,
        isPaused: savedIsPaused,
      );
      rethrow;
    }
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

  void clearMachines() {
    _appliedRoutineId = null;
    _isEditingRoutine = false;
    _emitDraft(draft.copyWith(machines: const []));
    if (isWorkoutStarted || isWorkoutFinished) resetWorkoutTimer();
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
        startedAt: startedAt,
        endedAt: endedAt,
        elapsed: elapsed,
        isPaused: isPaused,
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
          startedAt: startedAt,
          endedAt: endedAt,
          elapsed: elapsed,
          isPaused: isPaused,
        ),
      );
    }
  }

  void _emitDraft(WorkoutDraft nextDraft) {
    _emitEditing(
      nextDraft,
      clearError: true,
      startedAt: startedAt,
      endedAt: endedAt,
      elapsed: elapsed,
      isPaused: isPaused,
    );
    _persistDraft(nextDraft);
  }

  void _emitTiming(
    WorkoutDraft nextDraft, {
    DateTime? startedAt,
    DateTime? endedAt,
    Duration? elapsed,
    bool? isPaused,
  }) {
    _emitEditing(
      nextDraft,
      clearError: true,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      elapsed: elapsed ?? this.elapsed,
      isPaused: isPaused ?? this.isPaused,
    );
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
    bool clearTiming = false,
    DateTime? startedAt,
    DateTime? endedAt,
    Duration? elapsed,
    bool? isPaused,
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
        startedAt: clearTiming ? null : startedAt ?? current?.startedAt,
        endedAt: clearTiming ? null : endedAt ?? current?.endedAt,
        elapsed: clearTiming
            ? Duration.zero
            : elapsed ?? current?.elapsed ?? Duration.zero,
        isPaused: clearTiming ? false : isPaused ?? current?.isPaused ?? false,
      ),
    );
  }

  @override
  Future<void> close() {
    _workoutTimer?.cancel();
    return super.close();
  }
}
