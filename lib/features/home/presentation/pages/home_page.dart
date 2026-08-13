import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/home/presentation/widgets/home_appbar.dart';
import 'package:lift_log/features/home/presentation/widgets/home_loading_shimmer.dart';
import 'package:lift_log/features/home/presentation/widgets/home_stats_section.dart';
import 'package:lift_log/features/home/presentation/widgets/workout_calendar.dart';
import 'package:lift_log/features/home/presentation/widgets/workout_overview_section.dart';

import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: switch (state) {
            HomeInitial() => AppText('home_initial_state'.tr),
            HomeLoading() => const HomeLoadingShimmer(),
            HomeLoaded() => Column(
              children: [
                HomeAppBar(),

                SizedBox(height: AppSpacing.sm),
                WorkoutOverviewSection(
                  workoutCount: context.read<HomeCubit>().workoutCount,
                  lastWorkoutDate: context.read<HomeCubit>().lastWorkoutDate,
                ),
                SizedBox(height: AppSpacing.md),
                HomeStatsSection(
                  gymCount: context.read<HomeCubit>().gymCount,
                  machineCount: context.read<HomeCubit>().machineCount,
                ),

                SizedBox(height: AppSpacing.md),

                WorkoutCalendar(
                  workoutDates: context.read<HomeCubit>().workoutDates,
                ),
                SizedBox(height: AppSpacing.md),
              ],
            ),
            HomeError(:final message) => AppText(
              '${'home_error'.tr}: $message',
            ),
          },
        );
      },
    );
  }
}
