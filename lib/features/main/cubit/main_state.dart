import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState({required this.selectedIndex});

  final int selectedIndex;
}

class MainInitial extends MainState {
  const MainInitial({super.selectedIndex = 0});

  @override
  List<Object?> get props => [selectedIndex];
}

class MainTabSelected extends MainState {
  const MainTabSelected({required super.selectedIndex});

  @override
  List<Object?> get props => [selectedIndex];
}
