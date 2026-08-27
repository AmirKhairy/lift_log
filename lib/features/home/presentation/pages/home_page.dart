import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/home/presentation/widgets/home_appbar.dart';
import 'package:lift_log/features/home/presentation/widgets/home_loading_shimmer.dart';
import 'package:lift_log/features/home/presentation/widgets/home_stats_section.dart';
import 'package:lift_log/features/home/presentation/widgets/workout_calendar.dart';
import 'package:lift_log/features/home/presentation/widgets/workout_overview_section.dart';

import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final ScrollController _scrollController;

  late final Animation<double> _appBarAnimation;
  late final Animation<double> _overviewAnimation;
  late final Animation<double> _statsAnimation;

  late final Animation<Offset> _appBarSlideAnimation;
  late final Animation<Offset> _overviewSlideAnimation;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _appBarAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
    );

    _overviewAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
    );

    _statsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
    );

    _appBarSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_appBarAnimation);

    _overviewSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_overviewAnimation);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeLoaded) {
          _startAnimation();
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: switch (state) {
            HomeInitial() => AppText('home_initial_state'.tr),
            HomeLoading() => const HomeLoadingShimmer(),
            HomeLoaded() => Column(
              children: [
                FadeTransition(
                  opacity: _appBarAnimation,
                  child: SlideTransition(
                    position: _appBarSlideAnimation,
                    child: HomeAppBar(scrollController: _scrollController),
                  ),
                ),

                SizedBox(height: AppSpacing.sm),
                FadeTransition(
                  opacity: _overviewAnimation,
                  child: SlideTransition(
                    position: _overviewSlideAnimation,
                    child: WorkoutOverviewSection(
                      workoutCount: context.read<HomeCubit>().workoutCount,
                      lastWorkoutDate: context
                          .read<HomeCubit>()
                          .lastWorkoutDate,
                      onViewHistory: () =>
                          context.push(AppRoutes.workoutHistory),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                HomeStatsSection(
                  machineCount: context.read<HomeCubit>().machineCount,
                  animation: _statsAnimation,
                  onAddWorkout: () async {
                    final saved = await context.push<bool>(AppRoutes.workout);
                    if (saved == true && context.mounted) {
                      await context.read<HomeCubit>().refresh();
                    }
                  },
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
