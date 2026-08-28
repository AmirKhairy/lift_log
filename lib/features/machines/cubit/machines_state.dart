import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/utils/app_enums.dart';

sealed class MachinesState extends Equatable {
  const MachinesState();

  MuscleGroup get selectedMuscleGroup => MuscleGroup.values.first;

  @override
  List<Object?> get props => [];
}

final class MachinesInitial extends MachinesState {
  const MachinesInitial();
}

final class MachinesLoding extends MachinesState {
  const MachinesLoding(this.muscleGroup);

  final MuscleGroup muscleGroup;

  @override
  MuscleGroup get selectedMuscleGroup => muscleGroup;

  @override
  List<Object?> get props => [muscleGroup];
}

final class MachinesLoadedSuccess extends MachinesState {
  const MachinesLoadedSuccess({
    required this.machines,
    required this.muscleGroup,
  });

  final List<MachineModel> machines;
  final MuscleGroup muscleGroup;

  List<MachineModel> get filteredMachines =>
      machines.where((machine) => machine.muscleGroup == muscleGroup).toList();

  @override
  MuscleGroup get selectedMuscleGroup => muscleGroup;

  @override
  List<Object?> get props => [machines, muscleGroup];
}

final class MachinesError extends MachinesState {
  const MachinesError(this.message, {required this.muscleGroup});

  final String message;
  final MuscleGroup muscleGroup;

  @override
  MuscleGroup get selectedMuscleGroup => muscleGroup;

  @override
  List<Object?> get props => [message, muscleGroup];
}
