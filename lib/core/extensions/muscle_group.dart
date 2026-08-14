import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/utils/app_enums.dart';

extension MuscleGroupExtension on MuscleGroup {
  String get displayName {
    switch (this) {
      case MuscleGroup.chest:
        return 'chest'.tr;
      case MuscleGroup.back:
        return 'back'.tr;
      case MuscleGroup.shoulders:
        return 'shoulders'.tr;
      case MuscleGroup.arms:
        return 'arms'.tr;
      case MuscleGroup.legs:
        return 'legs'.tr;
      case MuscleGroup.glutes:
        return 'glutes'.tr;
      case MuscleGroup.core:
        return 'core'.tr;
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
