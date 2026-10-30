import 'package:equatable/equatable.dart';

class BodyWeightEntry extends Equatable {
  const BodyWeightEntry({
    required this.id,
    required this.userId,
    required this.weight,
    required this.measuredAt,
  });

  final String id;
  final String userId;
  final double weight;
  final DateTime measuredAt;

  factory BodyWeightEntry.fromJson(Map<String, dynamic> json) {
    return BodyWeightEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      weight: (json['weight'] as num).toDouble(),
      measuredAt: DateTime.parse(json['measured_at'] as String).toLocal(),
    );
  }

  @override
  List<Object?> get props => [id, userId, weight, measuredAt];
}

class WeightGoal extends Equatable {
  const WeightGoal({
    required this.id,
    required this.userId,
    required this.targetWeight,
    required this.startedAt,
    this.endedAt,
  });

  final String id;
  final String userId;
  final double targetWeight;
  final DateTime startedAt;
  final DateTime? endedAt;

  factory WeightGoal.fromJson(Map<String, dynamic> json) {
    return WeightGoal(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      targetWeight: (json['target_weight'] as num).toDouble(),
      startedAt: DateTime.parse(json['started_at'] as String).toLocal(),
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String).toLocal(),
    );
  }

  bool get isActive => endedAt == null;

  @override
  List<Object?> get props => [id, userId, targetWeight, startedAt, endedAt];
}

class BodyProgressStats extends Equatable {
  const BodyProgressStats({
    required this.entries,
    required this.selectedEntries,
    required this.currentWeight,
    required this.startingWeight,
    required this.highestWeight,
    required this.lowestWeight,
    required this.totalChange,
    required this.weeklyChange,
    required this.monthlyChange,
    required this.yearlyChange,
    this.bmi,
  });

  final List<BodyWeightEntry> entries;
  final List<BodyWeightEntry> selectedEntries;
  final double? currentWeight;
  final double? startingWeight;
  final double? highestWeight;
  final double? lowestWeight;
  final double? totalChange;
  final double? weeklyChange;
  final double? monthlyChange;
  final double? yearlyChange;
  final double? bmi;

  static BodyProgressStats calculate({
    required List<BodyWeightEntry> entries,
    required DateTime now,
    required int days,
    double? heightCm,
  }) {
    final sorted = [...entries]
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    final selected = days == 0
        ? sorted
        : sorted
              .where(
                (entry) => !entry.measuredAt.isBefore(
                  now.subtract(Duration(days: days)),
                ),
              )
              .toList();

    double? changeFor(int period) {
      final latest = sorted.isEmpty ? null : sorted.last;
      if (latest == null) return null;
      final cutoff = latest.measuredAt.subtract(Duration(days: period));
      final previous = sorted
          .where((entry) => !entry.measuredAt.isAfter(cutoff))
          .lastOrNull;
      return previous == null ? null : latest.weight - previous.weight;
    }

    final current = sorted.isEmpty ? null : sorted.last.weight;
    final heightMeters = (heightCm ?? 0) / 100;
    return BodyProgressStats(
      entries: List.unmodifiable(sorted),
      selectedEntries: List.unmodifiable(selected),
      currentWeight: current,
      startingWeight: sorted.isEmpty ? null : sorted.first.weight,
      highestWeight: sorted.isEmpty
          ? null
          : sorted.map((entry) => entry.weight).reduce((a, b) => a > b ? a : b),
      lowestWeight: sorted.isEmpty
          ? null
          : sorted.map((entry) => entry.weight).reduce((a, b) => a < b ? a : b),
      totalChange: sorted.length < 2
          ? null
          : sorted.last.weight - sorted.first.weight,
      weeklyChange: changeFor(7),
      monthlyChange: changeFor(30),
      yearlyChange: changeFor(365),
      bmi: current != null && heightMeters > 0
          ? current / (heightMeters * heightMeters)
          : null,
    );
  }

  @override
  List<Object?> get props => [
    entries,
    selectedEntries,
    currentWeight,
    startingWeight,
    highestWeight,
    lowestWeight,
    totalChange,
    weeklyChange,
    monthlyChange,
    yearlyChange,
    bmi,
  ];
}
