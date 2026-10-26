import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/features/main/cubit/main_cubit.dart';

class MainFloatingActionButton extends StatelessWidget {
  const MainFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final added = await context.push<Object>(AppRoutes.addMachine);

        if (!context.mounted || added == null) return;

        await context.read<MainCubit>().refreshAfterMachineAdded();
      },
      backgroundColor: context.theme.colorScheme.primary,
      foregroundColor: context.theme.colorScheme.onPrimary,
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }
}
