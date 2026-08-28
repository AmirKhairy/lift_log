import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/machines/cubit/machines_cubit.dart';
import 'package:lift_log/features/machines/cubit/machines_state.dart';
import 'package:lift_log/features/machines/presentation/widgets/machine_item_widget.dart';
import 'package:lift_log/features/machines/presentation/widgets/machines_empty_view.dart';
import 'package:lift_log/features/machines/presentation/widgets/machines_loading.dart';

class MachinesList extends StatelessWidget {
  const MachinesList({super.key, required this.state});

  final MachinesState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      MachinesInitial() => AppText('machines_initial_state'.tr),
      MachinesLoding() => ListView.builder(
        itemCount: 4,
        itemBuilder: (_, index) {
          return const MachineShimmer();
        },
      ),
      MachinesLoadedSuccess(:final filteredMachines)
          when filteredMachines.isEmpty =>
        const MachinesEmptyView(hasAnyMachines: true),
      MachinesLoadedSuccess(:final filteredMachines) => ListView.builder(
        itemCount: filteredMachines.length,
        itemBuilder: (context, index) {
          final machine = filteredMachines[index];
          return MachineItemWidget(
            machine: machine,
            index: index,
            onChanged: () {
              context.read<MachinesCubit>().refresh();
            },
            onDelete: () {
              context.read<MachinesCubit>().deleteMachine(machine);
            },
          );
        },
      ),
      MachinesError(:final message) => AppText(
        '${'machines_error'.tr}: $message',
      ),
    };
  }
}
