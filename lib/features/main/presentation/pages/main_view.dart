import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/features/home/presentation/pages/home_page.dart';
import 'package:lift_log/features/machines/presentation/pages/machines_page.dart';
import 'package:lift_log/features/main/cubit/main_cubit.dart';
import 'package:lift_log/features/main/cubit/main_state.dart';
import 'package:lift_log/features/main/presentation/widgets/main_floating_action_button.dart';
import 'package:lift_log/features/main/presentation/widgets/main_navigation_bar.dart';
import 'package:lift_log/features/profile/presentation/pages/profile_page.dart';
import 'package:lift_log/features/videos/presentation/pages/videos_page.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MainCubit>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return AppScaffold(
          padding: EdgeInsets.zero,
          floatingActionButton: state.selectedIndex == 1
              ? const MainFloatingActionButton()
              : null,
          body: IndexedStack(
            index: state.selectedIndex,
            children: const [
              HomePage(),
              MachinesPage(),
              VideosPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: MainNavigationBar(
            selectedIndex: state.selectedIndex,
            onDestinationSelected: (index) {
              final cubit = context.read<MainCubit>();
              if (index == state.selectedIndex) {
                cubit.refreshSelectedTab();
                return;
              }

              cubit.selectTab(index);
            },
          ),
        );
      },
    );
  }
}
