import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/utils/app_enums.dart';

enum TargetMuscle {
  upperChest,
  flatChest,
  lowerChest,
  lats,
  upperBack,
  lowerBack,
  traps,
  frontShoulders,
  lateralShoulders,
  rearShoulders,
  biceps,
  triceps,
  forearms,
  quadriceps,
  hamstrings,
  calves,
  adductors,
  abductors,
  gluteusMaximus,
  gluteusMedius,
  abdominals,
  obliques,
  lowerAbs,
  cardiovascular,
}

class TargetMuscleOption {
  const TargetMuscleOption(this.value, this.group);

  final TargetMuscle value;
  final MuscleGroup group;

  String get displayName => _key.tr;

  String get _key => value.name;
}

extension TargetMuscleExtension on TargetMuscle {
  String toJson() => name;

  static TargetMuscle fromString(String value) {
    return TargetMuscle.values.firstWhere(
      (muscle) => muscle.name == value,
      orElse: () => throw Exception('Invalid target muscle: $value'),
    );
  }
}

List<TargetMuscleOption> targetMusclesFor(MuscleGroup group) {
  final values = switch (group) {
    MuscleGroup.chest => const [
      TargetMuscle.upperChest,
      TargetMuscle.flatChest,
      TargetMuscle.lowerChest,
    ],
    MuscleGroup.back => const [
      TargetMuscle.lats,
      TargetMuscle.upperBack,
      TargetMuscle.lowerBack,
      TargetMuscle.traps,
    ],
    MuscleGroup.shoulders => const [
      TargetMuscle.frontShoulders,
      TargetMuscle.lateralShoulders,
      TargetMuscle.rearShoulders,
    ],
    MuscleGroup.arms => const [
      TargetMuscle.biceps,
      TargetMuscle.triceps,
      TargetMuscle.forearms,
    ],
    MuscleGroup.legs => const [
      TargetMuscle.quadriceps,
      TargetMuscle.hamstrings,
      TargetMuscle.calves,
      TargetMuscle.adductors,
      TargetMuscle.abductors,
    ],
    MuscleGroup.glutes => const [
      TargetMuscle.gluteusMaximus,
      TargetMuscle.gluteusMedius,
    ],
    MuscleGroup.core => const [
      TargetMuscle.abdominals,
      TargetMuscle.obliques,
      TargetMuscle.lowerAbs,
    ],
    MuscleGroup.cardio => const [TargetMuscle.cardiovascular],
  };

  return values.map((value) => TargetMuscleOption(value, group)).toList();
}

TargetMuscleOption? targetMuscleOptionFor(TargetMuscle? value) {
  if (value == null) return null;
  for (final group in MuscleGroup.values) {
    for (final option in targetMusclesFor(group)) {
      if (option.value == value) return option;
    }
  }
  return null;
}
