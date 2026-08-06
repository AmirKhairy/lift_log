import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_states.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  static const int pageCount = 4;

  void pageChanged(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void nextPressed() {
    if (state.currentIndex >= pageCount - 1) {
      complete();
      return;
    }

    emit(state.copyWith(currentIndex: state.currentIndex + 1));
  }

  void complete() {
    emit(state.copyWith(isCompleted: true));
  }
}
