import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/services/api_services/machines_service.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/utils/target_muscle.dart';

import 'machines_state.dart';

class MachinesCubit extends Cubit<MachinesState> {
  MachinesCubit() : super(const MachinesInitial());

  final MachinesService machinesService = MachinesService.instance;

  MuscleGroup? _selectedMuscleGroup;
  TargetMuscle? _selectedTargetMuscle;
  bool _hasLoaded = false;
  Future<void>? _loadingFuture;
  List<MachineModel>? get machines => machinesService.machines;

  Future<void> loadIfNeeded() {
    if (_hasLoaded) {
      return Future.value();
    }

    if (_loadingFuture != null) {
      return _loadingFuture!;
    }

    final future = _loadMachine(isRefresh: false);
    _loadingFuture = future;
    return future.whenComplete(() => _loadingFuture = null);
  }

  Future<void> refresh() async {
    await _loadMachine(isRefresh: true);
  }

  Future<void> deleteMachine(MachineModel machine) async {
    final machineId = machine.id;
    if (machineId == null) return;

    final updatedMachines = (machines ?? [])
        .where((item) => item.id != machineId)
        .toList();
    machinesService.machines = updatedMachines;
    emit(
      MachinesLoadedSuccess(
        machines: updatedMachines,
        muscleGroup: _selectedMuscleGroup,
        targetMuscle: _selectedTargetMuscle,
      ),
    );

    try {
      await machinesService.deleteMachine(
        machineId,
        imageUrl: machine.imageUrl,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      emit(
        MachinesError(
          e.toString(),
          muscleGroup: _selectedMuscleGroup,
          targetMuscle: _selectedTargetMuscle,
        ),
      );
      await refresh();
      rethrow;
    }
  }

  void selectMuscleGroup(MuscleGroup muscleGroup) {
    if (_selectedMuscleGroup == muscleGroup) return;

    _selectedMuscleGroup = muscleGroup;
    _selectedTargetMuscle = null;
    switch (state) {
      case MachinesLoadedSuccess(:final machines):
        emit(
          MachinesLoadedSuccess(machines: machines, muscleGroup: muscleGroup),
        );
      case MachinesLoding():
        emit(MachinesLoding(muscleGroup));
      case MachinesError(:final message):
        emit(MachinesError(message, muscleGroup: muscleGroup));
      case MachinesInitial():
        break;
    }
  }

  void selectTargetMuscle(TargetMuscle? targetMuscle) {
    _selectedTargetMuscle = targetMuscle;
    switch (state) {
      case MachinesLoadedSuccess(:final machines):
        emit(
          MachinesLoadedSuccess(
            machines: machines,
            muscleGroup: _selectedMuscleGroup,
            targetMuscle: targetMuscle,
          ),
        );
      case MachinesLoding():
        emit(MachinesLoding(_selectedMuscleGroup, targetMuscle));
      case MachinesError(:final message):
        emit(
          MachinesError(
            message,
            muscleGroup: _selectedMuscleGroup,
            targetMuscle: targetMuscle,
          ),
        );
      case MachinesInitial():
        break;
    }
  }

  void selectAllMuscleGroups() {
    if (_selectedMuscleGroup == null) return;

    _selectedMuscleGroup = null;
    _selectedTargetMuscle = null;
    switch (state) {
      case MachinesLoadedSuccess(:final machines):
        emit(MachinesLoadedSuccess(machines: machines, muscleGroup: null));
      case MachinesLoding():
        emit(const MachinesLoding(null));
      case MachinesError(:final message):
        emit(MachinesError(message, muscleGroup: null));
      case MachinesInitial():
        break;
    }
  }

  Future<void> _loadMachine({required bool isRefresh}) async {
    emit(MachinesLoding(_selectedMuscleGroup, _selectedTargetMuscle));

    try {
      await machinesService.getMachines();

      _hasLoaded = true;
      emit(
        MachinesLoadedSuccess(
          machines: machines ?? [],
          muscleGroup: _selectedMuscleGroup,
          targetMuscle: _selectedTargetMuscle,
        ),
      );
    } catch (e, s) {
      _hasLoaded = false;
      debugPrintStack(stackTrace: s);
      emit(
        MachinesError(
          e.toString(),
          muscleGroup: _selectedMuscleGroup,
          targetMuscle: _selectedTargetMuscle,
        ),
      );
    }
  }
}
