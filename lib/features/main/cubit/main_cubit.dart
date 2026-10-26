import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_state.dart';

typedef MainTabAction = Future<void> Function();

class MainCubit extends Cubit<MainState> {
  MainCubit({
    MainTabAction? loadHome,
    MainTabAction? loadMachines,
    MainTabAction? loadVideos,
    MainTabAction? loadProfile,
    MainTabAction? refreshHome,
    MainTabAction? refreshMachines,
    MainTabAction? refreshVideos,
    MainTabAction? refreshProfile,
    MainTabAction? refreshAfterMachineAdded,
  }) : _loadHome = loadHome ?? _noOp,
       _loadMachines = loadMachines ?? _noOp,
       _loadVideos = loadVideos ?? _noOp,
       _loadProfile = loadProfile ?? _noOp,
       _refreshHome = refreshHome ?? _noOp,
       _refreshMachines = refreshMachines ?? _noOp,
       _refreshVideos = refreshVideos ?? _noOp,
       _refreshProfile = refreshProfile ?? _noOp,
       _refreshAfterMachineAdded = refreshAfterMachineAdded ?? _noOp,
       super(const MainInitial());

  static const tabCount = 4;

  static Future<void> _noOp() async {}

  final MainTabAction _loadHome;
  final MainTabAction _loadMachines;
  final MainTabAction _loadVideos;
  final MainTabAction _loadProfile;
  final MainTabAction _refreshHome;
  final MainTabAction _refreshMachines;
  final MainTabAction _refreshVideos;
  final MainTabAction _refreshProfile;
  final MainTabAction _refreshAfterMachineAdded;

  Future<void> initialize() => _loadForIndex(0);

  Future<void> selectTab(int index) async {
    if (index < 0 || index >= tabCount || index == state.selectedIndex) {
      return;
    }

    emit(MainTabSelected(selectedIndex: index));
    await _loadForIndex(index);
  }

  Future<void> refreshSelectedTab() => _refreshForIndex(state.selectedIndex);

  Future<void> refreshAfterMachineAdded() => _refreshAfterMachineAdded();

  Future<void> _loadForIndex(int index) {
    switch (index) {
      case 0:
        return _loadHome();
      case 1:
        return _loadMachines();
      case 2:
        return _loadVideos();
      case 3:
        return _loadProfile();
    }

    return Future.value();
  }

  Future<void> _refreshForIndex(int index) async {
    switch (index) {
      case 0:
        await _refreshHome();
      case 1:
        await Future.wait([_refreshMachines(), _refreshHome()]);
      case 2:
        await _refreshVideos();
      case 3:
        await _refreshProfile();
    }
  }
}
