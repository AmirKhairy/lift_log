import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/services/api_services/workout_service.dart';

import 'workout_history_state.dart';

class WorkoutHistoryCubit extends Cubit<WorkoutHistoryState> {
  WorkoutHistoryCubit({WorkoutService? workoutService})
    : _workoutService = workoutService ?? WorkoutService.instance,
      super(const WorkoutHistoryInitial());

  final WorkoutService _workoutService;

  Future<void> load() async {
    emit(const WorkoutHistoryLoading());

    try {
      final sessions = await _workoutService.getWorkoutSessions();
      emit(WorkoutHistoryLoaded(sessions));
    } catch (error) {
      emit(WorkoutHistoryError(error.toString()));
    }
  }
}
