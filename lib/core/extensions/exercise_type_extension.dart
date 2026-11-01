import 'package:lift_log/core/utils/app_enums.dart';

extension ExerciseTypeExtension on ExerciseType {
  String get databaseValue => switch (this) {
    ExerciseType.weightReps => 'weight_reps',
    ExerciseType.reps => 'reps',
    ExerciseType.time => 'time',
  };

  String get localizationKey => switch (this) {
    ExerciseType.weightReps => 'exercise_type_weight_reps',
    ExerciseType.reps => 'exercise_type_reps',
    ExerciseType.time => 'exercise_type_time',
  };

  static ExerciseType fromDatabaseValue(String? value) => switch (value) {
    'reps' => ExerciseType.reps,
    'time' => ExerciseType.time,
    _ => ExerciseType.weightReps,
  };
}
