import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/features/add_machine/cubit/add_machine_cubit.dart';
import 'package:lift_log/features/add_machine/presentation/pages/add_machine_view.dart';

class AddMachinePage extends StatelessWidget {
  const AddMachinePage({super.key, this.machineToEdit});

  final MachineModel? machineToEdit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddMachineCubit(machineToEdit: machineToEdit)..hydrate(),
      child: AddMachineView(machineToEdit: machineToEdit),
    );
  }
}
