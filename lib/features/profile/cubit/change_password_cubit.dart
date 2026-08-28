import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/services/api_services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({AuthService? authService})
    : _authService = authService ?? AuthService(),
      super(const ChangePasswordInitial());

  final AuthService _authService;

  Future<void> changePassword({
    required String password,
    required GlobalKey<FormState> formKey,
  }) async {
    if (!formKey.currentState!.validate()) return;

    emit(const ChangePasswordLoading());

    try {
      await _authService.updatePassword(password);
      emit(const ChangePasswordSuccess());
    } on AuthException catch (e) {
      emit(ChangePasswordFailure(e.message));
    } catch (_) {
      emit(ChangePasswordFailure('something_went_wrong'.tr));
    }
  }
}
