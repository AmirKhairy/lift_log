import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/user_model.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.user,
    required this.workoutDates,
    required this.machineCount,
  });

  final UserModel user;
  final List<DateTime> workoutDates;
  final int machineCount;

  int get workoutCount => workoutDates.length;

  DateTime? get lastWorkoutDate {
    if (workoutDates.isEmpty) return null;

    return workoutDates.reduce(
      (latest, date) => date.isAfter(latest) ? date : latest,
    );
  }

  @override
  List<Object?> get props => [user, workoutDates, machineCount];
}

final class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
