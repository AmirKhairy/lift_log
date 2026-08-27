import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/features/workout_history/cubit/workout_history_cubit.dart';
import 'package:lift_log/features/workout_history/cubit/workout_history_state.dart';
import 'package:lift_log/features/workout_history/presentation/widgets/workout_history_empty_view.dart';
import 'package:lift_log/features/workout_history/presentation/widgets/workout_history_error_view.dart';
import 'package:lift_log/features/workout_history/presentation/widgets/workout_session_card.dart';

class WorkoutHistoryView extends StatelessWidget {
  const WorkoutHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutHistoryCubit, WorkoutHistoryState>(
      builder: (context, state) {
        return switch (state) {
          WorkoutHistoryInitial() || WorkoutHistoryLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          WorkoutHistoryError(:final message) => WorkoutHistoryErrorView(
            message: message,
            onRetry: context.read<WorkoutHistoryCubit>().load,
          ),
          WorkoutHistoryLoaded(:final sessions) when sessions.isEmpty =>
            const WorkoutHistoryEmptyView(),
          WorkoutHistoryLoaded(:final sessions) => RefreshIndicator(
            onRefresh: context.read<WorkoutHistoryCubit>().load,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: sessions.length,
              separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) =>
                  WorkoutSessionCard(session: sessions[index]),
            ),
          ),
        };
      },
    );
  }
}
