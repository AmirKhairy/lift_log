import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/body_progress_models.dart';
import 'package:lift_log/core/services/api_services/body_progress_service.dart';

import 'body_progress_state.dart';

class BodyProgressCubit extends Cubit<BodyProgressState> {
  BodyProgressCubit({
    required this.heightCm,
    required this.userId,
    this.onWeightChanged,
    BodyProgressService? service,
  }) : _service = service ?? BodyProgressService.instance,
       super(const BodyProgressInitial());

  final double heightCm;
  final String userId;
  final ValueChanged<double>? onWeightChanged;
  final BodyProgressService _service;

  Future<void> load() async {
    final selectedDays = state is BodyProgressLoaded
        ? (state as BodyProgressLoaded).selectedDays
        : 0;
    emit(const BodyProgressLoading());
    try {
      final results = await Future.wait([
        _service.getWeightEntries(),
        _service.getGoals(),
      ]);
      emit(
        BodyProgressLoaded(
          entries: results[0] as List<BodyWeightEntry>,
          goals: results[1] as List<WeightGoal>,
          selectedDays: selectedDays,
          heightCm: heightCm,
        ),
      );
    } catch (error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      emit(BodyProgressError(error.toString()));
    }
  }

  void selectPeriod(int days) {
    final current = state;
    if (current is BodyProgressLoaded) {
      emit(_loaded(current, selectedDays: days));
    }
  }

  Future<void> addWeight(double weight, DateTime measuredAt) async {
    final current = _currentLoaded;
    if (current == null) return;

    final optimisticEntry = BodyWeightEntry(
      id: 'optimistic-${DateTime.now().microsecondsSinceEpoch}',
      userId: userId,
      weight: weight,
      measuredAt: measuredAt,
    );
    final optimisticEntries = _sortedEntries([
      ...current.entries,
      optimisticEntry,
    ]);
    emit(
      BodyProgressSaving(
        entries: optimisticEntries,
        goals: current.goals,
        selectedDays: current.selectedDays,
        heightCm: heightCm,
      ),
    );
    _syncProfileWeight(optimisticEntries);

    try {
      final saved = await _service.addWeight(
        weight: weight,
        measuredAt: measuredAt,
      );
      final latest = _currentLoaded;
      if (latest == null) return;
      final entries = _sortedEntries([
        for (final entry in latest.entries)
          if (entry.id == optimisticEntry.id) saved else entry,
      ]);
      emit(_loaded(latest, entries: entries));
      _syncProfileWeight(entries);
    } catch (error) {
      emit(_loaded(current));
      emit(BodyProgressError(error.toString()));
    }
  }

  Future<void> updateWeight(
    String id,
    double weight,
    DateTime measuredAt,
  ) async {
    final current = _currentLoaded;
    if (current == null) return;
    final previous = current.entries.firstWhere((entry) => entry.id == id);
    final optimisticEntry = BodyWeightEntry(
      id: previous.id,
      userId: previous.userId,
      weight: weight,
      measuredAt: measuredAt,
    );
    final optimisticEntries = _sortedEntries([
      for (final entry in current.entries)
        if (entry.id == id) optimisticEntry else entry,
    ]);
    emit(
      BodyProgressSaving(
        entries: optimisticEntries,
        goals: current.goals,
        selectedDays: current.selectedDays,
        heightCm: heightCm,
      ),
    );
    _syncProfileWeight(optimisticEntries);

    try {
      final saved = await _service.updateWeight(
        id: id,
        weight: weight,
        measuredAt: measuredAt,
      );
      final latest = _currentLoaded;
      if (latest == null) return;
      final entries = _sortedEntries([
        for (final entry in latest.entries)
          if (entry.id == id) saved else entry,
      ]);
      emit(_loaded(latest, entries: entries));
      _syncProfileWeight(entries);
    } catch (error) {
      emit(_loaded(current));
      emit(BodyProgressError(error.toString()));
    }
  }

  Future<void> deleteWeight(String id) async {
    final current = _currentLoaded;
    if (current == null) return;
    if (current.currentEntry?.id == id) return;
    emit(
      BodyProgressDeleting(
        entries: current.entries,
        goals: current.goals,
        selectedDays: current.selectedDays,
        heightCm: heightCm,
        deletingId: id,
      ),
    );
    final remaining = current.entries.where((entry) => entry.id != id).toList();
    _syncProfileWeight(remaining);

    try {
      await _service.deleteWeight(id);
      final latest = _currentLoaded;
      if (latest != null) emit(_loaded(latest, entries: remaining));
      _syncProfileWeight(remaining);
    } catch (error) {
      emit(_loaded(current));
      _syncProfileWeight(current.entries);
      emit(BodyProgressError(error.toString()));
    }
  }

  Future<void> setGoal(double targetWeight) async {
    final current = _currentLoaded;
    if (current == null) return;
    final now = DateTime.now();
    final optimisticGoal = WeightGoal(
      id: 'optimistic-${now.microsecondsSinceEpoch}',
      userId: userId,
      targetWeight: targetWeight,
      startedAt: now,
    );
    final goals = [
      for (final goal in current.goals)
        if (goal.isActive)
          WeightGoal(
            id: goal.id,
            userId: goal.userId,
            targetWeight: goal.targetWeight,
            startedAt: goal.startedAt,
            endedAt: now,
          )
        else
          goal,
      optimisticGoal,
    ];
    emit(
      BodyProgressGoalSaving(
        entries: current.entries,
        goals: goals,
        selectedDays: current.selectedDays,
        heightCm: heightCm,
      ),
    );

    try {
      final saved = await _service.setGoal(targetWeight);
      final latest = _currentLoaded;
      if (latest == null) return;
      emit(
        _loaded(
          latest,
          goals: [
            for (final goal in latest.goals)
              if (goal.id == optimisticGoal.id) saved else goal,
          ],
        ),
      );
    } catch (error) {
      emit(_loaded(current));
      emit(BodyProgressError(error.toString()));
    }
  }

  Future<void> removeGoal(String id) async {
    final current = _currentLoaded;
    if (current == null) return;
    final now = DateTime.now();
    final goals = [
      for (final goal in current.goals)
        if (goal.id == id)
          WeightGoal(
            id: goal.id,
            userId: goal.userId,
            targetWeight: goal.targetWeight,
            startedAt: goal.startedAt,
            endedAt: now,
          )
        else
          goal,
    ];
    emit(
      BodyProgressGoalDeleting(
        entries: current.entries,
        goals: current.goals,
        selectedDays: current.selectedDays,
        heightCm: heightCm,
      ),
    );

    try {
      await _service.removeGoal(id);
      final latest = _currentLoaded;
      if (latest != null) emit(_loaded(latest, goals: goals));
    } catch (error) {
      emit(_loaded(current));
      emit(BodyProgressError(error.toString()));
    }
  }

  BodyProgressLoaded? get _currentLoaded {
    final current = state;
    return current is BodyProgressLoaded ? current : null;
  }

  BodyProgressLoaded _loaded(
    BodyProgressLoaded current, {
    List<BodyWeightEntry>? entries,
    List<WeightGoal>? goals,
    int? selectedDays,
  }) {
    return BodyProgressLoaded(
      entries: entries ?? current.entries,
      goals: goals ?? current.goals,
      selectedDays: selectedDays ?? current.selectedDays,
      heightCm: heightCm,
    );
  }

  List<BodyWeightEntry> _sortedEntries(List<BodyWeightEntry> entries) {
    return [...entries]..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
  }

  void _syncProfileWeight(List<BodyWeightEntry> entries) {
    if (entries.isNotEmpty) {
      onWeightChanged?.call(_sortedEntries(entries).last.weight);
    }
  }
}
