import 'package:flutter_test/flutter_test.dart';
import 'package:lift_log/features/timer/cubit/timer_cubit.dart';
import 'package:lift_log/features/timer/cubit/timer_states.dart';

void main() {
  group('TimerCubit', () {
    late TimerCubit cubit;

    setUp(() {
      cubit = TimerCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('starts in count-up mode', () {
      expect(cubit.state, isA<TimerInitial>());
      expect(cubit.state.mode, TimerMode.countUp);
      expect(cubit.state.duration, Duration.zero);
    });

    test('stores a countdown duration in state', () {
      const duration = Duration(minutes: 2, seconds: 30);

      cubit.setCountdownDuration(duration);

      expect(cubit.state, isA<TimerStopped>());
      expect(cubit.state.mode, TimerMode.countDown);
      expect(cubit.state.duration, duration);
      expect(cubit.state.totalDuration, duration);
    });

    test('reset restores the configured countdown duration', () {
      const duration = Duration(minutes: 1);

      cubit.setCountdownDuration(duration);
      cubit.startTimer();
      cubit.resetTimer();

      expect(cubit.state, isA<TimerInitial>());
      expect(cubit.state.duration, duration);
      expect(cubit.state.totalDuration, duration);
      expect(cubit.isRunning, isFalse);
    });

    test('clearing the countdown disables starting it', () {
      cubit.setCountdownDuration(const Duration(minutes: 1));
      cubit.clearCountdownDuration();

      expect(cubit.state, isA<TimerInitial>());
      expect(cubit.state.mode, TimerMode.countDown);
      expect(cubit.state.duration, Duration.zero);
      expect(cubit.isRunning, isFalse);
    });
  });
}
