import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/services/api_services/user_service.dart';
import 'package:lift_log/core/services/api_services/workout_service.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({UserService? userService, WorkoutService? workoutService})
    : _userService = userService ?? UserService.instance,
      _workoutService = workoutService ?? WorkoutService.instance,
      super(const HomeInitial());

  final UserService _userService;
  final WorkoutService _workoutService;

  bool _hasLoaded = false;
  Future<void>? _loadingFuture;
  Future<void> loadIfNeeded() {
    if (_hasLoaded) {
      return Future.value();
    }

    if (_loadingFuture != null) {
      return _loadingFuture!;
    }

    final future = _loadData();
    _loadingFuture = future;
    return future.whenComplete(() => _loadingFuture = null);
  }

  Future<void> refresh() async {
    await _loadData();
  }

  Future<void> _loadData() async {
    emit(const HomeLoading());

    try {
      final user = await _userService.getUserData();
      final workoutDates = await _loadWorkoutDates();
      final machineCount = await _workoutService.getMachineCount();
      _hasLoaded = true;
      emit(
        HomeLoaded(
          user: user,
          workoutDates: List.unmodifiable(workoutDates),
          machineCount: machineCount,
        ),
      );
    } catch (e, s) {
      _hasLoaded = false;

      debugPrint('HomeCubit: Failed to load Home data: $e');
      debugPrintStack(stackTrace: s);

      emit(HomeError(e.toString()));
    }
  }

  Future<List<DateTime>> _loadWorkoutDates() async {
    final now = DateTime.now();

    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 1);

    return _workoutService.getWorkoutDates(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
