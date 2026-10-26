import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/constants/app_keys.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/helpers/logger.dart';
import 'package:lift_log/core/services/storage_service.dart';
import 'package:lift_log/core/services/api_services/auth_service.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/widgets/app_picker.dart';
import 'package:lift_log/features/auth/cubit/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthService? authService})
    : _service = authService ?? AuthService(),
      super(const AuthInitial());

  final AuthService _service;

  bool _isFormValid(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> _saveUserId(String userId) async {
    await StorageService.saveString(AppKeys.userId, userId);
  }

  // ========================================== Login ==========================================

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      if (!_isFormValid(formKey)) return;

      emit(const EmailAuthLoading());

      final user = await _service.login(email: email, password: password);
      await _saveUserId(user.id);
      emit(EmailAuthSuccess(userId: user.id));
    } on AuthException catch (e) {
      emit(EmailAuthFailure(e.message));
    } catch (_) {
      emit(EmailAuthFailure('something_went_wrong'.tr));
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      emit(const GoogleAuthLoading());
      final user = await _service.loginWithGoogle();
      if (user == null) {
        emit(const AuthInitial());
        return;
      }
      bool completed = await _service.isProfileCompleted(user.id);

      if (completed) {
        await _saveUserId(user.id);
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
    } catch (e) {
      AppLogger.error('Google login failed: $e');
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
    emit(const SelectAge());
  }

  void setHeight(double value) {
    height = value;
    emit(const SelectHeight());
  }

  void setWeight(double value) {
    weight = value;
    emit(const SelectWeight());
  }

  void setGender(Gender value) {
    gender = value;
    emit(const SelectGender());
  }

  Future<void> openAgePicker(BuildContext context) async {
    final value = await AppPicker.show<int>(
      context: context,
      items: [for (var i = 10; i <= 70; i++) i],
      itemLabel: (e) => e.toString(),
      initialValue: age,
      pickerTitle: 'age',
    );

    if (value != null) {
      setAge(value);
    }
  }

  Future<void> openGenderPicker(BuildContext context) async {
    final value = await AppPicker.show<Gender>(
      context: context,
      items: Gender.values,
      itemLabel: (e) => e.name,
      initialValue: gender,
      pickerTitle: 'gender',
    );

    if (value != null) {
      setGender(value);
    }
  }

  Future<void> openHeightPicker(BuildContext context) async {
    final value = await AppPicker.show<double>(
      context: context,
      items: [for (var i = 100; i <= 250; i++) i / 1],
      itemLabel: (e) => '$e ${'height_unit'.tr}',
      initialValue: height,
      pickerTitle: 'height',
    );

    if (value != null) {
      setHeight(value);
    }
  }

  Future<void> openWeightPicker(BuildContext context) async {
    final value = await AppPicker.show<double>(
      context: context,
      items: [for (var i = 15; i <= 300; i++) i / 1],
      itemLabel: (e) => '$e ${'weight_unit'.tr}',
      initialValue: weight,
      pickerTitle: 'weight',
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
      if (!_isFormValid(formKey)) return;

      emit(const RegisterAuthLoading());

      final user = await _service.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        age: age!,
        height: height!,
        weight: weight!,
        gender: gender!.name,
      );
      await _saveUserId(user.id);
      emit(RegisterAuthSuccess(userId: user.id));
    } on AuthException catch (e) {
      emit(RegisterAuthFailure(e.message));
    } catch (e) {
      AppLogger.error('Email registration failed: $e');
      emit(RegisterAuthFailure('something_went_wrong'.tr));
    }
  }

  Future<void> registerWithGoogle({
    required String userId,
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      if (!_isFormValid(formKey)) return;

      emit(const GoogleRegisterAuthLoading());

      await _service.registerWithGoogle(
        userId: userId,
        age: age!,
        height: height!,
        weight: weight!,
        gender: gender!.name,
      );
      await _saveUserId(userId);
      emit(GoogleRegisterAuthSuccess(userId: userId));
    } on AuthException catch (e) {
      emit(GoogleRegisterAuthFailure(e.message));
    } catch (e) {
      AppLogger.error('Google registration failed: $e');
      emit(GoogleRegisterAuthFailure('something_went_wrong'.tr));
    }
  }

  Future<void> sendResetPasswordEmail({
    required String email,
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      if (!_isFormValid(formKey)) return;

      emit(const ResetPasswordEmailLoading());

      await _service.sendResetPasswordEmail(email);
      emit(const ResetPasswordEmailSuccess());
    } on AuthException catch (e) {
      emit(ResetPasswordEmailFailure(e.message));
    } catch (_) {
      emit(ResetPasswordEmailFailure('something_went_wrong'.tr));
    }
  }

  Future<void> updatePassword({
    required String password,
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      if (!_isFormValid(formKey)) return;

      emit(const ResetPasswordLoading());
      await _service.updatePassword(password);
      emit(const ResetPasswordSuccess());
    } on AuthException catch (e) {
      emit(ResetPasswordFailure(e.message));
    } catch (_) {
      emit(ResetPasswordFailure('something_went_wrong'.tr));
    }
  }
}
