import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/constants/app_keys.dart';
import 'package:lift_log/core/services/storage_service.dart';

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
    StorageService.saveBool(AppKeys.onboardingCompleted, true);
    emit(state.copyWith(isCompleted: true));
  }
}
