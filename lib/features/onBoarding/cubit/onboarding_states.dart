import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  int get currentIndex;
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial({this.currentIndex = 0});

  @override
  final int currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}

class OnboardingPageChanged extends OnboardingState {
  const OnboardingPageChanged({required this.currentIndex});

  @override
  final int currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}

class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted({required this.currentIndex});

  @override
  final int currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}
