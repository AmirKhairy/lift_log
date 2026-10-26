import 'package:flutter_test/flutter_test.dart';
import 'package:lift_log/core/services/storage_service.dart';
import 'package:lift_log/features/onBoarding/cubit/onboarding_cubit.dart';
import 'package:lift_log/features/onBoarding/cubit/onboarding_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  test('starts in the initial state at the first page', () {
    final cubit = OnboardingCubit();

    expect(cubit.state, const OnboardingInitial());
    expect(cubit.state.currentIndex, 0);
  });

  test('emits a page-specific state when the page changes', () {
    final cubit = OnboardingCubit();

    cubit.pageChanged(2);

    expect(cubit.state, const OnboardingPageChanged(currentIndex: 2));
  });

  test('nextPressed advances through explicit page states', () {
    final cubit = OnboardingCubit();

    cubit.nextPressed();
    cubit.nextPressed();

    expect(cubit.state, const OnboardingPageChanged(currentIndex: 2));
  });

  test('completing onboarding emits a completed state', () async {
    final cubit = OnboardingCubit();

    cubit.pageChanged(3);
    cubit.complete();

    expect(cubit.state, const OnboardingCompleted(currentIndex: 3));
    expect(StorageService.getBool('onboarding_completed'), isTrue);
  });
}
