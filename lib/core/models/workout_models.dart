import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/machine_model.dart';

class WorkoutSetDraft extends Equatable {
  const WorkoutSetDraft({required this.setNumber, this.weight, this.reps});

  final int setNumber;
  final double? weight;
  final int? reps;

  factory WorkoutSetDraft.fromJson(Map<String, dynamic> json) {
    return WorkoutSetDraft(
      setNumber: (json['set_number'] as num).toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      reps: (json['reps'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'set_number': setNumber,
    'weight': weight,
    'reps': reps,
  };

  WorkoutSetDraft copyWith({int? setNumber, double? weight, int? reps}) {
    return WorkoutSetDraft(
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
    );
  }

  @override
  List<Object?> get props => [setNumber, weight, reps];
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
    this.notes = '',
    this.machines = const [],
  }) : performedAt = performedAt ?? _defaultPerformedAt;

  static DateTime get _defaultPerformedAt => DateTime.now();

  final DateTime performedAt;
  final String notes;
  final List<WorkoutMachineDraft> machines;

  factory WorkoutDraft.fromJson(Map<String, dynamic> json) {
    return WorkoutDraft(
      performedAt: DateTime.parse(json['performed_at'] as String),
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
    'notes': notes,
    'machines': machines.map((machine) => machine.toJson()).toList(),
  };

  WorkoutDraft copyWith({
    DateTime? performedAt,
    String? notes,
    List<WorkoutMachineDraft>? machines,
  }) {
    return WorkoutDraft(
      performedAt: performedAt ?? this.performedAt,
      notes: notes ?? this.notes,
      machines: machines ?? this.machines,
    );
  }

  @override
  List<Object?> get props => [performedAt, notes, machines];
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
              weight: (set['weight'] as num).toDouble(),
              reps: (set['reps'] as num).toInt(),
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
    this.logNotes,
  });

  final DateTime performedAt;
  final String? logNotes;
  final List<WorkoutSetModel> sets;

  factory MachineWorkoutHistoryItem.fromJson(Map<String, dynamic> json) {
    final sessionJson = json['workout_sessions'];
    final session = sessionJson is Map
        ? Map<String, dynamic>.from(sessionJson)
        : <String, dynamic>{};
    final performedAtRaw = session['performed_at'] as String?;
    final setsJson = json['workout_sets'];

    return MachineWorkoutHistoryItem(
      performedAt: performedAtRaw != null
          ? DateTime.parse(performedAtRaw).toLocal()
          : DateTime.parse(json['created_at'] as String).toLocal(),
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
  List<Object?> get props => [performedAt, logNotes, sets];
}

class WorkoutSetModel extends Equatable {
  const WorkoutSetModel({
    required this.setNumber,
    required this.weight,
    required this.reps,
  });

  final int setNumber;
  final double weight;
  final int reps;

  factory WorkoutSetModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSetModel(
      setNumber: (json['set_number'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      reps: (json['reps'] as num).toInt(),
    );
  }

  @override
  List<Object?> get props => [setNumber, weight, reps];
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
    required this.logs,
    this.notes,
  });

  final String id;
  final DateTime performedAt;
  final List<WorkoutLogModel> logs;
  final String? notes;

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) {
    final logsJson = json['workout_logs'];

    return WorkoutSessionModel(
      id: json['id'] as String,
      performedAt: DateTime.parse(json['performed_at'] as String).toLocal(),
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
  List<Object?> get props => [id, performedAt, logs, notes];
}
