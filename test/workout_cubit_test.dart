import 'package:flutter_test/flutter_test.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';
import 'package:lift_log/features/workout/cubit/workout_state.dart';

void main() {
  final machine = MachineModel(
    id: 'machine-1',
    name: 'Leg Press',
    muscleGroup: MuscleGroup.legs,
  );

  test('requires a machine and valid sets before saving', () {
    expect(WorkoutDraft().validate(), 'workout_empty_machines');

    final draft = WorkoutDraft(machines: [workoutMachineDraft(machine)]);
    expect(draft.validate(), 'workout_invalid_weight');
  });

  test('adds machines and renumbers sets after removal', () {
    final cubit = WorkoutCubit(initialMachine: machine);

    cubit.addSet(0);
    cubit.removeSet(0, 0);

    final state = cubit.state as WorkoutEditing;
    expect(state.draft.machines, hasLength(1));
    expect(state.draft.machines.first.sets, hasLength(1));
    expect(state.draft.machines.first.sets.first.setNumber, 1);
  });
}
