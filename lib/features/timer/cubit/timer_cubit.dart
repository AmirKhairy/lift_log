import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lift_log/core/helpers/logger.dart';
import 'package:lift_log/features/timer/cubit/timer_states.dart';

class TimerCubit extends Cubit<TimerStates> {
  TimerCubit()
    : _audioPlayer = AudioPlayer(),
      super(
        const TimerInitial(mode: TimerMode.countUp, duration: Duration.zero),
      );

  Timer? _timer;

  final AudioPlayer _audioPlayer;

  TimerMode get mode => state.mode;

  Duration get duration => state.duration;

  bool get isRunning => state.isRunning;

  bool get hasStarted => state.hasStarted;

  Duration _countdownDuration = Duration.zero;

  DateTime? _startTime;

  Duration _durationAtStart = Duration.zero;

  void setMode(TimerMode mode) {
    _cancelTimer();
    _countdownDuration = Duration.zero;
    _durationAtStart = Duration.zero;

    emit(TimerInitial(mode: mode, duration: Duration.zero));
  }

  void setCountdownDuration(Duration duration) {
    if (duration <= Duration.zero) {
      clearCountdownDuration();
      return;
    }

    _cancelTimer();

    _countdownDuration = duration;
    _durationAtStart = duration;

    emit(
      TimerStopped(
        mode: TimerMode.countDown,
        duration: duration,
        totalDuration: duration,
      ),
    );
  }

  void clearCountdownDuration() {
    _cancelTimer();
    _countdownDuration = Duration.zero;
    _durationAtStart = Duration.zero;

    emit(
      const TimerInitial(
        mode: TimerMode.countDown,
        duration: Duration.zero,
      ),
    );
  }

  void startTimer() {
    if (isRunning) {
      return;
    }

    if (mode == TimerMode.countDown && state.duration <= Duration.zero) {
      return;
    }

    _startTime = DateTime.now();
    _durationAtStart = state.duration;

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _updateTimer(),
    );

    emit(
      TimerRunning(
        mode: mode,
        duration: state.duration,
        totalDuration: mode == TimerMode.countDown
            ? _countdownDuration
            : Duration.zero,
      ),
    );
  }

  void stopTimer() {
    if (!isRunning) {
      return;
    }

    _updateTimer();

    if (state is TimerCompleted) {
      return;
    }

    _timer?.cancel();
    _timer = null;

    _startTime = null;

    emit(
      TimerStopped(
        mode: mode,
        duration: state.duration,
        totalDuration: state.totalDuration,
      ),
    );
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;

    _startTime = null;
    _durationAtStart = Duration.zero;

    emit(
      TimerInitial(
        mode: mode,
        duration: mode == TimerMode.countDown
            ? _countdownDuration
            : Duration.zero,
        totalDuration: mode == TimerMode.countDown
            ? _countdownDuration
            : Duration.zero,
      ),
    );
  }

  void setQuickDuration(Duration duration) {
    setMode(TimerMode.countDown);
    setCountdownDuration(duration);
  }

  void _updateTimer() {
    if (_startTime == null) {
      return;
    }

    final elapsedSinceStart = DateTime.now().difference(_startTime!);

    if (mode == TimerMode.countUp) {
      final currentDuration = _durationAtStart + elapsedSinceStart;

      emit(TimerRunning(mode: TimerMode.countUp, duration: currentDuration));

      return;
    }

    final remaining = _durationAtStart - elapsedSinceStart;

    if (remaining <= Duration.zero) {
      _timer?.cancel();
      _timer = null;
      _startTime = null;

      _countdownDuration = _durationAtStart;

      emit(
        TimerCompleted(
          mode: TimerMode.countDown,
          totalDuration: _countdownDuration,
        ),
      );

      _playCompletionSound();

      return;
    }

    emit(
      TimerRunning(
        mode: TimerMode.countDown,
        duration: remaining,
        totalDuration: _countdownDuration,
      ),
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
    _startTime = null;
  }

  Future<void> _playCompletionSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      await _audioPlayer.play(
        AssetSource('sounds/timer_complete.mp3'),
        volume: 1,
        mode: PlayerMode.mediaPlayer,
      );
    } catch (error) {
      AppLogger.error('Error playing completion sound: $error');
    }
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _audioPlayer.dispose();

    return super.close();
  }
}
