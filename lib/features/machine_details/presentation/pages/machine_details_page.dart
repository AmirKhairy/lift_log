import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class MachineDetailsPage extends StatelessWidget {
  const MachineDetailsPage({super.key, required this.machine});
  final MachineModel machine;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: machine.name ?? 'machine_details',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(machine.notes ?? ''),
          const Spacer(),
          AppButton(
            title: 'log_this_machine',
            icon: const Icon(Icons.add_chart),
            onPressed: () => context.push(AppRoutes.workout, extra: machine),
          ),
        ],
      ),
    );
  }
}
