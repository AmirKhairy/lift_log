import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/machine_model.dart';

class WorkoutSetDraft extends Equatable {
  const WorkoutSetDraft({
    required this.setNumber,
    this.weight,
    this.reps,
    this.durationSeconds,
  });

  final int setNumber;
  final double? weight;
  final int? reps;
  final int? durationSeconds;

  factory WorkoutSetDraft.fromJson(Map<String, dynamic> json) {
    return WorkoutSetDraft(
      setNumber: (json['set_number'] as num).toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      reps: (json['reps'] as num?)?.toInt(),
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'set_number': setNumber,
    'weight': weight,
    'reps': reps,
    'duration_seconds': durationSeconds,
  };

  WorkoutSetDraft copyWith({
    int? setNumber,
    double? weight,
    int? reps,
    int? durationSeconds,
  }) {
    return WorkoutSetDraft(
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  List<Object?> get props => [setNumber, weight, reps, durationSeconds];
}

class WorkoutMachineDraft extends Equatable {
  const WorkoutMachineDraft({
    required this.machine,
    this.notes = '',
    this.sets = const [WorkoutSetDraft(setNumber: 1)],
  });

  final MachineModel machine;
  final String notes;
  final List<WorkoutSetDraft> sets;

  factory WorkoutMachineDraft.fromJson(Map<String, dynamic> json) {
    return WorkoutMachineDraft(
      machine: MachineModel.fromJson(
        Map<String, dynamic>.from(json['machine'] as Map),
      ),
      notes: json['notes'] as String? ?? '',
      sets: (json['sets'] as List<dynamic>? ?? [])
          .map(
            (item) => WorkoutSetDraft.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'machine': machine.toJson(),
    'notes': notes,
    'sets': sets.map((set) => set.toJson()).toList(),
  };

  WorkoutMachineDraft copyWith({
    MachineModel? machine,
    String? notes,
    List<WorkoutSetDraft>? sets,
  }) {
    return WorkoutMachineDraft(
      machine: machine ?? this.machine,
      notes: notes ?? this.notes,
      sets: sets ?? this.sets,
    );
  }

  @override
  List<Object?> get props => [machine, notes, sets];
}

class WorkoutDraft extends Equatable {
  WorkoutDraft({
    DateTime? performedAt,
    this.startedAt,
    this.endedAt,
    this.activeSince,
    this.elapsedSeconds = 0,
    this.isPaused = false,
    this.notes = '',
    this.machines = const [],
  }) : performedAt = performedAt ?? _defaultPerformedAt;

  static DateTime get _defaultPerformedAt => DateTime.now();

  final DateTime performedAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime? activeSince;
  final int elapsedSeconds;
  final bool isPaused;
  final String notes;
  final List<WorkoutMachineDraft> machines;

  factory WorkoutDraft.fromJson(Map<String, dynamic> json) {
    return WorkoutDraft(
      performedAt: DateTime.parse(json['performed_at'] as String),
      startedAt: (json['started_at'] as String?) == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      endedAt: (json['ended_at'] as String?) == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
      activeSince: (json['active_since'] as String?) == null
          ? null
          : DateTime.parse(json['active_since'] as String),
      elapsedSeconds: (json['elapsed_seconds'] as num?)?.toInt() ?? 0,
      isPaused: json['is_paused'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      machines: (json['machines'] as List<dynamic>? ?? [])
          .map(
            (item) => WorkoutMachineDraft.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'performed_at': performedAt.toIso8601String(),
    'started_at': startedAt?.toIso8601String(),
    'ended_at': endedAt?.toIso8601String(),
    'active_since': activeSince?.toIso8601String(),
    'elapsed_seconds': elapsedSeconds,
    'is_paused': isPaused,
    'notes': notes,
    'machines': machines.map((machine) => machine.toJson()).toList(),
  };

  WorkoutDraft copyWith({
    DateTime? performedAt,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? activeSince,
    bool clearActiveSince = false,
    bool clearStartedAt = false,
    bool clearEndedAt = false,
    int? elapsedSeconds,
    bool? isPaused,
    String? notes,
    List<WorkoutMachineDraft>? machines,
  }) {
    return WorkoutDraft(
      performedAt: performedAt ?? this.performedAt,
      startedAt: clearStartedAt ? null : startedAt ?? this.startedAt,
      endedAt: clearEndedAt ? null : endedAt ?? this.endedAt,
      activeSince: clearActiveSince ? null : activeSince ?? this.activeSince,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isPaused: isPaused ?? this.isPaused,
      notes: notes ?? this.notes,
      machines: machines ?? this.machines,
    );
  }

  @override
  List<Object?> get props => [
    performedAt,
    startedAt,
    endedAt,
    activeSince,
    elapsedSeconds,
    isPaused,
    notes,
    machines,
  ];
}

class RoutineModel extends Equatable {
  const RoutineModel({
    required this.id,
    required this.name,
    required this.exercises,
  });

  final String id;
  final String name;
  final List<WorkoutMachineDraft> exercises;

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    final exerciseJson =
        json['workout_routine_exercises'] as List<dynamic>? ?? [];
    return RoutineModel(
      id: json['id'] as String,
      name: json['name'] as String,
      exercises: exerciseJson.map((raw) {
        final item = Map<String, dynamic>.from(raw as Map);
        final machine = MachineModel.fromJson(
          Map<String, dynamic>.from(item['machines'] as Map),
        );
        final sets = (item['workout_routine_sets'] as List<dynamic>? ?? []).map(
          (rawSet) {
            final set = Map<String, dynamic>.from(rawSet as Map);
            return WorkoutSetDraft(
              setNumber: (set['set_number'] as num).toInt(),
              weight: (set['weight'] as num?)?.toDouble(),
              reps: (set['reps'] as num?)?.toInt(),
              durationSeconds: (set['duration_seconds'] as num?)?.toInt(),
            );
          },
        ).toList()..sort((a, b) => a.setNumber.compareTo(b.setNumber));
        return WorkoutMachineDraft(
          machine: machine,
          notes: item['notes'] as String? ?? '',
          sets: sets.isEmpty ? const [WorkoutSetDraft(setNumber: 1)] : sets,
        );
      }).toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, exercises];
}

class MachineWorkoutHistoryItem extends Equatable {
  const MachineWorkoutHistoryItem({
    required this.performedAt,
    required this.sets,
    this.startedAt,
    this.endedAt,
    this.logNotes,
  });

  final DateTime performedAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? logNotes;
  final List<WorkoutSetModel> sets;

  double get totalVolume => sets.length.toDouble();

  factory MachineWorkoutHistoryItem.fromJson(Map<String, dynamic> json) {
    final sessionJson = json['workout_sessions'];
    final session = sessionJson is Map
        ? Map<String, dynamic>.from(sessionJson)
        : <String, dynamic>{};
    final performedAtRaw = session['performed_at'] as String?;
    final startedAtRaw = session['started_at'] as String?;
    final endedAtRaw = session['ended_at'] as String?;
    final setsJson = json['workout_sets'];

    return MachineWorkoutHistoryItem(
      performedAt: performedAtRaw != null
          ? DateTime.parse(performedAtRaw).toLocal()
          : DateTime.parse(json['created_at'] as String).toLocal(),
      startedAt: startedAtRaw == null
          ? null
          : DateTime.parse(startedAtRaw).toLocal(),
      endedAt: endedAtRaw == null ? null : DateTime.parse(endedAtRaw).toLocal(),
      logNotes: json['notes'] as String?,
      sets:
          (setsJson as List<dynamic>? ?? [])
              .map(
                (item) => WorkoutSetModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList()
            ..sort((a, b) => a.setNumber.compareTo(b.setNumber)),
    );
  }

  @override
  List<Object?> get props => [performedAt, startedAt, endedAt, logNotes, sets];
}

class WorkoutSetModel extends Equatable {
  const WorkoutSetModel({
    required this.setNumber,
    this.weight,
    this.reps,
    this.durationSeconds,
  });

  final int setNumber;
  final double? weight;
  final int? reps;
  final int? durationSeconds;

  factory WorkoutSetModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSetModel(
      setNumber: (json['set_number'] as num).toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      reps: (json['reps'] as num?)?.toInt(),
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
    );
  }

  @override
  List<Object?> get props => [setNumber, weight, reps, durationSeconds];
}

class WorkoutLogModel extends Equatable {
  const WorkoutLogModel({
    required this.machine,
    required this.sets,
    this.notes,
  });

  final MachineModel machine;
  final List<WorkoutSetModel> sets;
  final String? notes;

  factory WorkoutLogModel.fromJson(Map<String, dynamic> json) {
    final machineJson = json['machines'];
    final setsJson = json['workout_sets'];

    return WorkoutLogModel(
      machine: MachineModel.fromJson(
        Map<String, dynamic>.from(machineJson as Map),
      ),
      notes: json['notes'] as String?,
      sets:
          (setsJson as List<dynamic>? ?? [])
              .map(
                (item) => WorkoutSetModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList()
            ..sort((a, b) => a.setNumber.compareTo(b.setNumber)),
    );
  }

  @override
  List<Object?> get props => [machine, sets, notes];
}

class WorkoutSessionModel extends Equatable {
  const WorkoutSessionModel({
    required this.id,
    required this.performedAt,
    this.startedAt,
    this.endedAt,
    required this.logs,
    this.notes,
  });

  final String id;
  final DateTime performedAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final List<WorkoutLogModel> logs;
  final String? notes;

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) {
    final logsJson = json['workout_logs'];

    return WorkoutSessionModel(
      id: json['id'] as String,
      performedAt: DateTime.parse(json['performed_at'] as String).toLocal(),
      startedAt: (json['started_at'] as String?) == null
          ? null
          : DateTime.parse(json['started_at'] as String).toLocal(),
      endedAt: (json['ended_at'] as String?) == null
          ? null
          : DateTime.parse(json['ended_at'] as String).toLocal(),
      notes: json['notes'] as String?,
      logs: (logsJson as List<dynamic>? ?? [])
          .map(
            (item) => WorkoutLogModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, performedAt, startedAt, endedAt, logs, notes];
}
