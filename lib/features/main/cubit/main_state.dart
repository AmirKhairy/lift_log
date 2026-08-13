import 'package:equatable/equatable.dart';

class MainState extends Equatable {
  const MainState({this.selectedIndex = 0});

  final int selectedIndex;

  MainState copyWith({int? selectedIndex}) {
    return MainState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object> get props => [selectedIndex];
}
