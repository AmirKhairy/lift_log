import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/constants/app_keys.dart';
import 'package:lift_log/core/services/storage_service.dart';

import 'onboarding_states.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingInitial());

  static const int pageCount = 4;

  void pageChanged(int index) {
    if (index < 0 || index >= pageCount || state is OnboardingCompleted) {
      return;
    }

    emit(OnboardingPageChanged(currentIndex: index));
  }

  void nextPressed() {
    if (state.currentIndex >= pageCount - 1) {
      complete();
      return;
    }

    emit(OnboardingPageChanged(currentIndex: state.currentIndex + 1));
  }

  void complete() {
    StorageService.saveBool(AppKeys.onboardingCompleted, true);
    emit(OnboardingCompleted(currentIndex: state.currentIndex));
  }
}
