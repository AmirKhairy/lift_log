import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/helpers/logger.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/services/api_services/machines_service.dart';
import 'package:lift_log/core/services/api_services/tutorial_videos_service.dart';
import 'package:lift_log/core/services/api_services/workout_service.dart';
import 'package:lift_log/features/machine_details/cubit/machine_details_state.dart';

class MachineDetailsCubit extends Cubit<MachineDetailsState> {
  MachineDetailsCubit({
    required this._machine,
    TutorialVideosService? tutorialVideosService,
    WorkoutService? workoutService,
    MachinesService? machinesService,
    Future<TutorialVideosModel?> Function(String id)? getTutorialById,
    Future<List<MachineWorkoutHistoryItem>> Function(String machineId)?
    getLogsForMachine,
    Future<void> Function(String machineId, {String? imageUrl})?
    deleteMachineFn,
  }) : _getTutorialById =
           getTutorialById ??
           (tutorialVideosService ?? TutorialVideosService.instance).getById,
       _getLogsForMachine =
           getLogsForMachine ??
           (workoutService ?? WorkoutService.instance).getLogsForMachine,
       _deleteMachineFn =
           deleteMachineFn ??
           (machinesService ?? MachinesService.instance).deleteMachine,
       super(const MachineDetailsInitial());

  MachineModel _machine;
  bool didMutate = false;

  final Future<TutorialVideosModel?> Function(String id) _getTutorialById;
  final Future<List<MachineWorkoutHistoryItem>> Function(String machineId)
  _getLogsForMachine;
  final Future<void> Function(String machineId, {String? imageUrl})
  _deleteMachineFn;

  Future<void> load() async {
    emit(const MachineDetailsLoading());
    await _loadDetails();
  }

  Future<void> replaceMachine(MachineModel machine) async {
    _machine = machine;
    didMutate = true;
    await load();
  }

  Future<void> deleteMachine() async {
    final currentState = state;
    if (currentState is! MachineDetailsLoaded) return;

    final machineId = currentState.machine.id;
    if (machineId == null) {
      emit(const MachineDetailsError('workout_invalid_machine'));
      emit(currentState);
      return;
    }

    emit(currentState.copyWith(isDeleting: true));

    try {
      await _deleteMachineFn(
        machineId,
        imageUrl: currentState.machine.imageUrl,
      );
      if (isClosed) return;
      didMutate = true;
      emit(const MachineDetailsDeleted());
    } catch (e) {
      AppLogger.error('Failed to delete machine: $e');
      if (isClosed) return;
      emit(MachineDetailsError(e.toString()));
      emit(currentState.copyWith(isDeleting: false));
    }
  }

  Future<void> _loadDetails() async {
    TutorialVideosModel? tutorial;
    String? tutorialError;
    var history = const <MachineWorkoutHistoryItem>[];
    String? historyError;

    final tutorialVideoId = _machine.tutorialVideoId;
    if (tutorialVideoId != null && tutorialVideoId.isNotEmpty) {
      try {
        tutorial = await _getTutorialById(tutorialVideoId);
      } catch (e) {
        AppLogger.error('Failed to load machine tutorial: $e');
        tutorialError = e.toString();
      }
    }

    final machineId = _machine.id;
    if (machineId != null && machineId.isNotEmpty) {
      try {
        history = await _getLogsForMachine(machineId);
      } catch (e) {
        AppLogger.error('Failed to load machine history: $e');
        historyError = e.toString();
      }
    }

    if (isClosed) return;

    emit(
      MachineDetailsLoaded(
        machine: _machine,
        tutorial: tutorial,
        history: history,
        tutorialError: tutorialError,
        historyError: historyError,
      ),
    );
  }
}
