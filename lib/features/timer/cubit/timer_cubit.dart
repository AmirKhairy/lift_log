import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Duration get countdownDuration => _countdownDuration;

  bool get isRunning => state.isRunning;

  bool get hasStarted => state.hasStarted;

  Duration elapsed = Duration.zero;

  Duration _countdownDuration = Duration.zero;

  DateTime? _startTime;

  Duration _durationAtStart = Duration.zero;

  void setMode(TimerMode mode) {
    if (isRunning) {
      stopTimer();
    }

    _timer?.cancel();

    elapsed = Duration.zero;
    _countdownDuration = Duration.zero;
    _startTime = null;
    _durationAtStart = Duration.zero;

    emit(TimerInitial(mode: mode, duration: Duration.zero));
  }

  void setCountdownDuration(Duration duration) {
    if (duration <= Duration.zero) {
      return;
    }

    _timer?.cancel();

    _countdownDuration = duration;
    _durationAtStart = duration;
    _startTime = null;

    emit(TimerStopped(mode: TimerMode.countDown, duration: duration));
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

    emit(TimerRunning(mode: mode, duration: state.duration));
  }

  void stopTimer() {
    if (!isRunning) {
      return;
    }

    _updateTimer();

    _timer?.cancel();
    _timer = null;

    _startTime = null;

    emit(TimerStopped(mode: mode, duration: state.duration));
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;

    elapsed = Duration.zero;
    _startTime = null;
    _durationAtStart = Duration.zero;

    emit(
      TimerInitial(
        mode: mode,
        duration: mode == TimerMode.countDown
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

      elapsed = currentDuration;

      emit(TimerRunning(mode: TimerMode.countUp, duration: currentDuration));

      return;
    }

    final remaining = _durationAtStart - elapsedSinceStart;

    if (remaining <= Duration.zero) {
      _timer?.cancel();
      _timer = null;
      _startTime = null;

      _countdownDuration = _durationAtStart;

      emit(const TimerCompleted(mode: TimerMode.countDown));

      _playCompletionSound();

      return;
    }

    emit(TimerRunning(mode: TimerMode.countDown, duration: remaining));
  }

  Future<void> _playCompletionSound() async {
    try {
      await _audioPlayer.stop();

      await _audioPlayer.play(AssetSource('sounds/timer_complete.mp3'));
    } catch (error) {
      debugPrint('Error playing completion sound: $error');
    }
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _audioPlayer.dispose();

    return super.close();
  }
}
