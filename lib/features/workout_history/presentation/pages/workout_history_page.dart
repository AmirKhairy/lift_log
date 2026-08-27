import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/features/workout_history/cubit/workout_history_cubit.dart';
import 'package:lift_log/features/workout_history/presentation/widgets/workout_history_view.dart';

class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutHistoryCubit()..load(),
      child: const AppScaffold(
        title: 'workout_history',
        body: WorkoutHistoryView(),
      ),
    );
  }
}
