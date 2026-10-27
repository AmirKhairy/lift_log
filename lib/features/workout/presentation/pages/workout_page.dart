import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';
import 'package:lift_log/features/workout/presentation/pages/workout_view.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key, this.initialMachine, this.machineOnly = false});

  final MachineModel? initialMachine;
  final bool machineOnly;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          WorkoutCubit(initialMachine: initialMachine)..loadMachines(),
      child: WorkoutView(machineOnly: machineOnly),
    );
  }
}
