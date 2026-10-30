import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/body_progress_models.dart';

sealed class BodyProgressState extends Equatable {
  const BodyProgressState();

  @override
  List<Object?> get props => [];
}

final class BodyProgressInitial extends BodyProgressState {
  const BodyProgressInitial();
}

final class BodyProgressLoading extends BodyProgressState {
  const BodyProgressLoading();
}

final class BodyProgressLoaded extends BodyProgressState {
  const BodyProgressLoaded({
    required this.entries,
    required this.goals,
    required this.selectedDays,
    required this.heightCm,
  });

  final List<BodyWeightEntry> entries;
  final List<WeightGoal> goals;
  final int selectedDays;
  final double heightCm;

  WeightGoal? get activeGoal =>
      goals.where((goal) => goal.isActive).firstOrNull;

  BodyWeightEntry? get currentEntry {
    if (entries.isEmpty) return null;
    return entries.reduce(
      (latest, entry) =>
          entry.measuredAt.isAfter(latest.measuredAt) ? entry : latest,
    );
  }

  BodyProgressStats get stats => BodyProgressStats.calculate(
    entries: entries,
    now: DateTime.now(),
    days: selectedDays,
    heightCm: heightCm,
  );

  double? get remainingWeight {
    final current = stats.currentWeight;
    final goal = activeGoal;
    return goal == null || current == null ? null : goal.targetWeight - current;
  }

  double? get goalStartWeight {
    final goal = activeGoal;
    if (goal == null) return null;
    return entries
        .where((entry) => !entry.measuredAt.isAfter(goal.startedAt))
        .lastOrNull
        ?.weight;
  }

  double? get goalProgress {
    final goal = activeGoal;
    final current = stats.currentWeight;
    final start = goalStartWeight;
    if (goal == null || current == null || start == null) return null;
    return (start - current).abs() /
        (start - goal.targetWeight).abs().clamp(0.001, double.infinity);
  }

  @override
  List<Object?> get props => [entries, goals, selectedDays, heightCm];
}

final class BodyProgressSaving extends BodyProgressLoaded {
  const BodyProgressSaving({
    required super.entries,
    required super.goals,
    required super.selectedDays,
    required super.heightCm,
  });
}

final class BodyProgressDeleting extends BodyProgressLoaded {
  const BodyProgressDeleting({
    required super.entries,
    required super.goals,
    required super.selectedDays,
    required super.heightCm,
    required this.deletingId,
  });

  final String deletingId;

  @override
  List<Object?> get props => [...super.props, deletingId];
}

final class BodyProgressGoalSaving extends BodyProgressLoaded {
  const BodyProgressGoalSaving({
    required super.entries,
    required super.goals,
    required super.selectedDays,
    required super.heightCm,
  });
}

final class BodyProgressGoalDeleting extends BodyProgressLoaded {
  const BodyProgressGoalDeleting({
    required super.entries,
    required super.goals,
    required super.selectedDays,
    required super.heightCm,
  });
}

final class BodyProgressError extends BodyProgressState {
  const BodyProgressError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
