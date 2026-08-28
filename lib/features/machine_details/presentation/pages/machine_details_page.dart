import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/features/machine_details/cubit/machine_details_cubit.dart';
import 'package:lift_log/features/machine_details/presentation/widgets/machine_details_view.dart';

class MachineDetailsPage extends StatelessWidget {
  const MachineDetailsPage({super.key, required this.machine});

  final MachineModel machine;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MachineDetailsCubit(machine: machine)..load(),
      child: const MachineDetailsView(),
    );
  }
}
