import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/services/api_services/user_service.dart';
import 'package:lift_log/core/services/api_services/workout_service.dart';
import 'package:lift_log/features/auth/models/user_model.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());
  final UserService _userService = UserService.instance;
  final WorkoutService _workoutService = WorkoutService.instance;

  bool _hasLoaded = false;
  Future<void>? _loadingFuture;
  UserModel? userModel;
  List<DateTime> workoutDates = [];
  int get workoutCount => workoutDates.length;
  int gymCount = 0;
  int machineCount = 0;

  Future<void> loadIfNeeded() {
    if (_hasLoaded) {
      return Future.value();
    }

    if (_loadingFuture != null) {
      return _loadingFuture!;
    }

    final future = _loadData(isRefresh: false);
    _loadingFuture = future;
    return future.whenComplete(() => _loadingFuture = null);
  }

  Future<void> refresh() async {
    await _loadData(isRefresh: true);
  }

  Future<void> _loadData({required bool isRefresh}) async {
    emit(const HomeLoading());

    try {
      if (isRefresh) {
      } else {}

      userModel = await _userService.getUserData();
      await _loadWorkoutDates();
      gymCount = await _workoutService.getGymCount();
      machineCount = await _workoutService.getMachineCount();
      _hasLoaded = true;
      emit(const HomeLoaded());
    } catch (e, s) {
      _hasLoaded = false;

      debugPrint('HomeCubit: Failed to load Home data: $e');
      debugPrintStack(stackTrace: s);

      emit(HomeError(e.toString()));
    }
  }

  Future<void> _loadWorkoutDates() async {
    final now = DateTime.now();

    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 1);

    workoutDates = await _workoutService.getWorkoutDates(
      startDate: startDate,
      endDate: endDate,
    );
  }

  DateTime? get lastWorkoutDate {
    if (workoutDates.isEmpty) return null;

    return workoutDates.first;
  }
}
