import 'package:equatable/equatable.dart';

enum TimerMode { countUp, countDown }

sealed class TimerStates extends Equatable {
  const TimerStates({
    required this.mode,
    required this.duration,
    required this.totalDuration,
    required this.isRunning,
    required this.hasStarted,
  });

  final TimerMode mode;
  final Duration duration;
  final Duration totalDuration;
  final bool isRunning;
  final bool hasStarted;

  @override
  List<Object?> get props => [
    mode,
    duration,
    totalDuration,
    isRunning,
    hasStarted,
  ];
}

final class TimerInitial extends TimerStates {
  const TimerInitial({
    required super.mode,
    required super.duration,
    super.totalDuration = Duration.zero,
  }) : super(isRunning: false, hasStarted: false);
}

final class TimerRunning extends TimerStates {
  const TimerRunning({
    required super.mode,
    required super.duration,
    super.totalDuration = Duration.zero,
  }) : super(isRunning: true, hasStarted: true);
}

final class TimerStopped extends TimerStates {
  const TimerStopped({
    required super.mode,
    required super.duration,
    super.totalDuration = Duration.zero,
  }) : super(isRunning: false, hasStarted: true);

  @override
  List<Object?> get props => [...super.props];
}

final class TimerCompleted extends TimerStates {
  const TimerCompleted({required super.mode, required super.totalDuration})
    : super(duration: Duration.zero, isRunning: false, hasStarted: true);
}
