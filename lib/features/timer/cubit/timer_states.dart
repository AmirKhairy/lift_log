import 'package:equatable/equatable.dart';

enum TimerMode { countUp, countDown }

sealed class TimerStates extends Equatable {
  const TimerStates({
    required this.mode,
    required this.duration,
    required this.isRunning,
    required this.hasStarted,
  });

  final TimerMode mode;
  final Duration duration;
  final bool isRunning;
  final bool hasStarted;

  @override
  List<Object?> get props => [mode, duration, isRunning, hasStarted];
}

final class TimerInitial extends TimerStates {
  const TimerInitial({required super.mode, required super.duration})
    : super(isRunning: false, hasStarted: false);
}

final class TimerRunning extends TimerStates {
  const TimerRunning({required super.mode, required super.duration})
    : super(isRunning: true, hasStarted: true);
}

final class TimerStopped extends TimerStates {
  const TimerStopped({required super.mode, required super.duration})
    : super(isRunning: false, hasStarted: true);

  @override
  List<Object?> get props => [...super.props];
}

final class TimerCompleted extends TimerStates {
  const TimerCompleted({required super.mode})
    : super(duration: Duration.zero, isRunning: false, hasStarted: true);
}
