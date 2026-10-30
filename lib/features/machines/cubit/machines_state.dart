import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/utils/target_muscle.dart';

sealed class MachinesState extends Equatable {
  const MachinesState();

  MuscleGroup? get selectedMuscleGroup => null;
  TargetMuscle? get selectedTargetMuscle => null;

  @override
  List<Object?> get props => [];
}

final class MachinesInitial extends MachinesState {
  const MachinesInitial();
}

final class MachinesLoding extends MachinesState {
  const MachinesLoding(this.muscleGroup, [this.targetMuscle]);

  final MuscleGroup? muscleGroup;
  final TargetMuscle? targetMuscle;

  @override
  MuscleGroup? get selectedMuscleGroup => muscleGroup;
  @override
  TargetMuscle? get selectedTargetMuscle => targetMuscle;

  @override
  List<Object?> get props => [muscleGroup, targetMuscle];
}

final class MachinesLoadedSuccess extends MachinesState {
  const MachinesLoadedSuccess({
    required this.machines,
    required this.muscleGroup,
    this.targetMuscle,
  });

  final List<MachineModel> machines;
  final MuscleGroup? muscleGroup;
  final TargetMuscle? targetMuscle;

  List<MachineModel> get filteredMachines => muscleGroup == null
      ? machines
      : machines
            .where(
              (machine) =>
                  machine.muscleGroup == muscleGroup &&
                  (targetMuscle == null ||
                      machine.targetMuscle == targetMuscle),
            )
            .toList();

  @override
  MuscleGroup? get selectedMuscleGroup => muscleGroup;
  @override
  TargetMuscle? get selectedTargetMuscle => targetMuscle;

  @override
  List<Object?> get props => [machines, muscleGroup, targetMuscle];
}

final class MachinesError extends MachinesState {
  const MachinesError(
    this.message, {
    required this.muscleGroup,
    this.targetMuscle,
  });

  final String message;
  final MuscleGroup? muscleGroup;
  final TargetMuscle? targetMuscle;

  @override
  MuscleGroup? get selectedMuscleGroup => muscleGroup;
  @override
  TargetMuscle? get selectedTargetMuscle => targetMuscle;

  @override
  List<Object?> get props => [message, muscleGroup, targetMuscle];
}
