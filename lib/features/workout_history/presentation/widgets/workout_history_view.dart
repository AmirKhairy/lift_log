import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/features/workout_history/cubit/workout_history_cubit.dart';
import 'package:lift_log/features/workout_history/cubit/workout_history_state.dart';
import 'package:lift_log/features/workout_history/presentation/widgets/workout_history_empty_view.dart';
import 'package:lift_log/features/workout_history/presentation/widgets/workout_history_error_view.dart';
import 'package:lift_log/features/workout_history/presentation/widgets/workout_day_section.dart';

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
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _groupSessionsByDay(sessions).length,
              itemBuilder: (context, index) {
                final groups = _groupSessionsByDay(sessions);
                final group = groups.entries.elementAt(index);

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == groups.length - 1 ? 0 : AppSpacing.lg,
                  ),
                  child: WorkoutDaySection(
                    date: group.key,
                    sessions: group.value,
                  ),
                );
              },
            ),
          ),
        };
      },
    );
  }

  Map<DateTime, List<WorkoutSessionModel>> _groupSessionsByDay(
    List<WorkoutSessionModel> sessions,
  ) {
    final groups = <DateTime, List<WorkoutSessionModel>>{};

    for (final session in sessions) {
      final day = DateTime(
        session.performedAt.year,
        session.performedAt.month,
        session.performedAt.day,
      );
      groups.putIfAbsent(day, () => []).add(session);
    }

    final sortedGroups = groups.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return {
      for (final entry in sortedGroups)
        entry.key: entry.value
          ..sort((a, b) => b.performedAt.compareTo(a.performedAt)),
    };
  }
}
