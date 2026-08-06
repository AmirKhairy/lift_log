import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/widgets/app_picker.dart';
import 'package:lift_log/features/auth/cubit/auth_state.dart';
import 'package:lift_log/features/auth/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthService _service = AuthService();

  // ========================================== Login ==========================================

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      if (formKey.currentState!.validate()) {
        emit(EmailAuthLoading());

        final user = await _service.login(email: email, password: password);
        emit(EmailAuthSuccess(userId: user.id));
      }
    } on AuthException catch (e) {
      emit(EmailAuthFailure(e.message));
    } catch (_) {
      emit(EmailAuthFailure('Something went wrong'));
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      emit(GoogleAuthLoading());
      final User user = await _service.loginWithGoogle();
      bool completed = await _service.isProfileCompleted(user.id);

      if (completed) {
        emit(GoogleAuthSuccess(userId: user.id));
      } else {
        emit(
          GoogleNewUserAuthSuccess(
            userId: user.id,
            userName: user.userMetadata?['name'] ?? '',
            userEmail: user.email ?? '',
          ),
        );
      }
    } on AuthException catch (e) {
      emit(GoogleAuthFailure(e.message));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(GoogleAuthFailure(e.toString()));
    }
  }

  // ========================================== Register ==========================================
  int? age;
  double? height;
  double? weight;
  Gender? gender;

  void setAge(int value) {
    age = value;
    emit(SelectAge());
  }

  void setHeight(double value) {
    height = value;
    emit(SelectHeight());
  }

  void setWeight(double value) {
    weight = value;
    emit(SelectWeight());
  }

  void setGender(Gender value) {
    gender = value;
    emit(SelectGender());
  }

  void openAgePicker(BuildContext context) async {
    final value = await AppPicker.show<int>(
      context: context,
      items: [for (var i = 10; i <= 70; i++) i],
      itemLabel: (e) => e.toString(),
      initialValue: age,
      pickerTitle: 'Age',
    );

    if (value != null) {
      setAge(value);
    }
  }

  void openGenderPicker(BuildContext context) async {
    final value = await AppPicker.show<Gender>(
      context: context,
      items: Gender.values,
      itemLabel: (e) => e.name,
      initialValue: gender,
      pickerTitle: 'Gender',
    );

    if (value != null) {
      setGender(value);
    }
  }

  void openHeightPicker(BuildContext context) async {
    final value = await AppPicker.show<double>(
      context: context,
      items: [for (var i = 100; i <= 250; i++) i / 1],
      itemLabel: (e) => '$e cm',
      initialValue: height,
      pickerTitle: 'Height',
    );

    if (value != null) {
      setHeight(value);
    }
  }

  void openWeightPicker(BuildContext context) async {
    final value = await AppPicker.show<double>(
      context: context,
      items: [for (var i = 15; i <= 300; i++) i / 1],
      itemLabel: (e) => '$e kg',
      initialValue: weight,
      pickerTitle: 'Weight',
    );

    if (value != null) {
      setWeight(value);
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      if (formKey.currentState!.validate()) {
        emit(RegisterAuthLoading());

        final user = await _service.registerWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
          age: age!,
          height: height!,
          weight: weight!,
          gender: gender!.name,
        );
        emit(RegisterAuthSuccess(userId: user.id));
      }
    } on AuthException catch (e) {
      emit(RegisterAuthFailure(e.message));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(RegisterAuthFailure('Something went wrong'));
    }
  }

  Future<void> registerWithGoogle({
    required String userId,
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      if (formKey.currentState!.validate()) {
        emit(GoogleRegisterAuthLoading());

        await _service.registerWithGoogle(
          userId: userId,
          age: age!,
          height: height!,
          weight: weight!,
          gender: gender!.name,
        );
        emit(GoogleRegisterAuthSuccess(userId: userId));
      }
    } on AuthException catch (e) {
      emit(GoogleRegisterAuthFailure(e.message));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(GoogleRegisterAuthFailure('Something went wrong'));
    }
  }

  Future<void> sendResetPasswordEmail({
    required String email,
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      if (formKey.currentState!.validate()) {
        emit(ResetPasswordEmailLoading());

        await _service.sendResetPasswordEmail(email);
        emit(ResetPasswordEmailSuccess());
      }
    } on AuthException catch (e) {
      emit(ResetPasswordEmailFailure(e.message));
    } catch (_) {
      emit(ResetPasswordEmailFailure('Something went wrong'));
    }
  }

  Future<void> updatePassword({
    required String password,
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      if (formKey.currentState!.validate()) {
        emit(ResetPasswordLoading());

        await _service.updatePassword(password);
        emit(ResetPasswordSuccess());
      }
    } on AuthException catch (e) {
      emit(ResetPasswordFailure(e.message));
    } catch (_) {
      emit(ResetPasswordFailure('Something went wrong'));
    }
  }
}
