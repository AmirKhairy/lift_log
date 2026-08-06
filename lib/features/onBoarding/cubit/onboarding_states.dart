import 'package:equatable/equatable.dart';

final class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentIndex = 0,
    this.isCompleted = false,
  });

  final int currentIndex;
  final bool isCompleted;

  OnboardingState copyWith({
    int? currentIndex,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [currentIndex, isCompleted];
}
