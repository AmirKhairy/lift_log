import 'package:flutter_test/flutter_test.dart';
import 'package:lift_log/features/main/cubit/main_cubit.dart';
import 'package:lift_log/features/main/cubit/main_state.dart';

void main() {
  test('starts on the home tab', () {
    final cubit = MainCubit();

    expect(cubit.state, const MainInitial());
    expect(cubit.state.selectedIndex, 0);
  });

  test('emits an explicit state when selecting a valid tab', () async {
    final cubit = MainCubit();

    await cubit.selectTab(2);

    expect(cubit.state, const MainTabSelected(selectedIndex: 2));
  });

  test('ignores invalid and repeated tab selections', () async {
    final cubit = MainCubit();

    await cubit.selectTab(-1);
    expect(cubit.state, const MainInitial());

    await cubit.selectTab(MainCubit.tabCount);
    expect(cubit.state, const MainInitial());

    await cubit.selectTab(0);
    expect(cubit.state, const MainInitial());
  });
}
