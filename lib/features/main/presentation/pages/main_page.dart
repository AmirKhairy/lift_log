import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/features/home/cubit/home_cubit.dart';
import 'package:lift_log/features/home/presentation/pages/home_page.dart';
import 'package:lift_log/features/main/cubit/main_cubit.dart';
import 'package:lift_log/features/main/cubit/main_state.dart';
import 'package:lift_log/features/profile/cubit/profile_cubit.dart';
import 'package:lift_log/features/profile/presentation/pages/profile_page.dart';
import 'package:lift_log/features/progress/cubit/progress_cubit.dart';
import 'package:lift_log/features/progress/presentation/pages/progress_page.dart';
import 'package:lift_log/features/videos/cubit/videos_cubit.dart';
import 'package:lift_log/features/videos/presentation/pages/videos_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => VideosCubit()),
        BlocProvider(create: (_) => ProgressCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
      ],
      child: const _MainView(),
    );
  }
}

class _MainView extends StatefulWidget {
  const _MainView();

  @override
  State<_MainView> createState() => _MainViewState();
}

class _MainViewState extends State<_MainView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadForIndex(0);
    });
  }

  void _loadForIndex(int index) {
    switch (index) {
      case 0:
        context.read<HomeCubit>().loadIfNeeded();
      case 1:
        context.read<VideosCubit>().loadIfNeeded();
      case 2:
        context.read<ProgressCubit>().loadIfNeeded();
      case 3:
        context.read<ProfileCubit>().loadIfNeeded();
    }
  }

  void _refreshForIndex(int index) {
    switch (index) {
      case 0:
        context.read<HomeCubit>().refresh();
      case 1:
        context.read<VideosCubit>().refresh();
      case 2:
        context.read<ProgressCubit>().refresh();
      case 3:
        context.read<ProfileCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return AppScaffold(
          padding: EdgeInsets.zero,
          body: IndexedStack(
            index: state.selectedIndex,
            children: const [
              HomePage(),
              ProgressPage(),
              VideosPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: context.theme.colorScheme.surface,
                elevation: 0,

                indicatorColor: context.theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),

                iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return IconThemeData(
                      color: context.theme.colorScheme.primary,
                      size: 28.sp,
                    );
                  }

                  return IconThemeData(
                    color: context.theme.colorScheme.onSurface.withValues(
                      alpha: 0.5,
                    ),
                    size: 28.sp,
                  );
                }),

                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return TextStyle(
                      color: context.theme.colorScheme.primary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    );
                  }

                  return TextStyle(
                    color: context.theme.colorScheme.onSurface.withValues(
                      alpha: 0.5,
                    ),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  );
                }),
              ),

              child: NavigationBar(
                height: 80.h,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                selectedIndex: state.selectedIndex,
                onDestinationSelected: (index) {
                  if (index == state.selectedIndex) {
                    _refreshForIndex(index);
                    return;
                  }

                  context.read<MainCubit>().selectTab(index);
                  _loadForIndex(index);
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home),
                    label: 'home'.tr,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.show_chart_outlined),
                    selectedIcon: const Icon(Icons.show_chart),
                    label: 'progress'.tr,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.play_circle_outline),
                    selectedIcon: const Icon(Icons.play_circle),
                    label: 'videos'.tr,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.person_outline),
                    selectedIcon: const Icon(Icons.person),
                    label: 'profile'.tr,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
