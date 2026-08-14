import 'package:lift_log/core/utils/app_enums.dart';

extension MuscleGroupExtension on MuscleGroup {
  String get displayName {
    switch (this) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.back:
        return 'Back';
      case MuscleGroup.shoulders:
        return 'Shoulders';
      case MuscleGroup.arms:
        return 'Arms';
      case MuscleGroup.legs:
        return 'Legs';
      case MuscleGroup.glutes:
        return 'Glutes';
      case MuscleGroup.core:
        return 'Core';
    }
  }

  static MuscleGroup fromString(String value) {
    switch (value.toLowerCase()) {
      case 'chest':
        return MuscleGroup.chest;
      case 'back':
        return MuscleGroup.back;
      case 'shoulders':
        return MuscleGroup.shoulders;
      case 'arms':
        return MuscleGroup.arms;
      case 'legs':
        return MuscleGroup.legs;
      case 'glutes':
        return MuscleGroup.glutes;
      case 'core':
        return MuscleGroup.core;
      default:
        throw Exception('Invalid muscle group: $value');
    }
  }

  String toJson() {
    return displayName.toLowerCase();
  }
}
