import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/user_model.dart';
import 'package:lift_log/core/services/api_services/user_service.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/widgets/app_picker.dart';

import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({
    required UserModel user,
    UserService? userService,
  }) : _userService = userService ?? UserService.instance,
       super(
         EditProfileInitial(
           name: user.name,
           age: user.age,
           gender: user.gender,
           height: user.height,
           weight: user.weight,
         ),
       );

  final UserService _userService;

  void setName(String value) {
    final current = state;
    if (current is EditProfileInitial) {
      emit(current.copyWith(name: value));
    }
  }

  void setAge(int value) {
    final current = state;
    if (current is EditProfileInitial) {
      emit(current.copyWith(age: value));
    }
  }

  void setGender(String value) {
    final current = state;
    if (current is EditProfileInitial) {
      emit(current.copyWith(gender: value));
    }
  }

  void setHeight(double value) {
    final current = state;
    if (current is EditProfileInitial) {
      emit(current.copyWith(height: value));
    }
  }

  void setWeight(double value) {
    final current = state;
    if (current is EditProfileInitial) {
      emit(current.copyWith(weight: value));
    }
  }

  Future<void> openAgePicker(BuildContext context) async {
    final current = state;
    if (current is! EditProfileInitial) return;

    final value = await AppPicker.show<int>(
      context: context,
      items: [for (var i = 10; i <= 70; i++) i],
      itemLabel: (e) => e.toString(),
      initialValue: current.age,
      pickerTitle: 'age',
    );

    if (value != null) {
      setAge(value);
    }
  }

  Future<void> openGenderPicker(BuildContext context) async {
    final current = state;
    if (current is! EditProfileInitial) return;

    final initialGender = current.gender != null
        ? Gender.values.firstWhere(
            (g) => g.name == current.gender,
            orElse: () => Gender.male,
          )
        : null;

    final value = await AppPicker.show<Gender>(
      context: context,
      items: Gender.values,
      itemLabel: (e) => e.name[0].toUpperCase() + e.name.substring(1),
      initialValue: initialGender,
      pickerTitle: 'gender',
    );

    if (value != null) {
      setGender(value.name);
    }
  }

  Future<void> openHeightPicker(BuildContext context) async {
    final current = state;
    if (current is! EditProfileInitial) return;

    final value = await AppPicker.show<double>(
      context: context,
      items: [for (var i = 100; i <= 250; i++) i / 1],
      itemLabel: (e) => '$e cm',
      initialValue: current.height,
      pickerTitle: 'height',
    );

    if (value != null) {
      setHeight(value);
    }
  }

  Future<void> openWeightPicker(BuildContext context) async {
    final current = state;
    if (current is! EditProfileInitial) return;

    final value = await AppPicker.show<double>(
      context: context,
      items: [for (var i = 15; i <= 300; i++) i / 1],
      itemLabel: (e) => '$e kg',
      initialValue: current.weight,
      pickerTitle: 'weight',
    );

    if (value != null) {
      setWeight(value);
    }
  }

  Future<void> save({required GlobalKey<FormState> formKey}) async {
    final current = state;
    if (current is! EditProfileInitial) return;

    if (!formKey.currentState!.validate()) return;

    emit(current.copyWith(isSaving: true));

    try {
      final user = await _userService.updateProfile(
        name: current.name.trim(),
        age: current.age!,
        gender: current.gender!,
        height: current.height!,
        weight: current.weight!,
      );

      emit(EditProfileSuccess(user));
    } catch (_) {
      emit(current.copyWith(isSaving: false));
      emit(EditProfileFailure('something_went_wrong'.tr));
    }
  }
}
