import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/features/home/cubit/home_cubit.dart';
import 'package:lift_log/features/machines/cubit/machines_cubit.dart';
import 'package:lift_log/features/main/cubit/main_cubit.dart';
import 'package:lift_log/features/main/presentation/pages/main_view.dart';
import 'package:lift_log/features/profile/cubit/profile_cubit.dart';
import 'package:lift_log/features/videos/cubit/videos_cubit.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => VideosCubit()),
        BlocProvider(create: (_) => MachinesCubit()),
        BlocProvider(
          create: (context) => MainCubit(
            loadHome: () => context.read<HomeCubit>().loadIfNeeded(),
            loadMachines: () => context.read<MachinesCubit>().loadIfNeeded(),
            loadVideos: () => context.read<VideosCubit>().loadIfNeeded(),
            loadProfile: () => context.read<ProfileCubit>().loadIfNeeded(),
            refreshHome: () => context.read<HomeCubit>().refresh(),
            refreshMachines: () => context.read<MachinesCubit>().refresh(),
            refreshVideos: () => context.read<VideosCubit>().refresh(),
            refreshProfile: () => context.read<ProfileCubit>().refresh(),
            refreshAfterMachineAdded: () =>
                context.read<MachinesCubit>().refresh(),
          ),
        ),
      ],
      child: const MainView(),
    );
  }
}
