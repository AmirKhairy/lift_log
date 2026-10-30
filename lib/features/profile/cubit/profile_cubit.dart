import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/constants/app_keys.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/services/api_services/auth_service.dart';
import 'package:lift_log/core/services/api_services/user_service.dart';
import 'package:lift_log/core/services/storage_service.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    UserService? userService,
    AuthService? authService,
  }) : _userService = userService ?? UserService.instance,
       _authService = authService ?? AuthService(),
       super(const ProfileInitial());

  final UserService _userService;
  final AuthService _authService;

  bool _hasLoaded = false;
  Future<void>? _loadingFuture;

  Future<void> loadIfNeeded() {
    if (_hasLoaded) {
      return Future.value();
    }

    return _loadOnce();
  }

  Future<void> refresh() => _loadOnce();

  void updateWeightLocally(double weight) {
    final current = state;
    if (current is ProfileUserState) {
      emit(ProfileLoaded(current.user.copyWith(weight: weight)));
    }
  }

  Future<void> _loadOnce() {
    final loadingFuture = _loadingFuture;
    if (loadingFuture != null) {
      return loadingFuture;
    }

    final future = _loadData();
    late final Future<void> trackedFuture;
    trackedFuture = future.whenComplete(() {
      if (identical(_loadingFuture, trackedFuture)) {
        _loadingFuture = null;
      }
    });
    _loadingFuture = trackedFuture;
    return trackedFuture;
  }

  Future<void> _loadData() async {
    emit(const ProfileLoading());

    try {
      final user = await _userService.getUserData();

      _hasLoaded = true;
      emit(ProfileLoaded(user));
    } catch (e, s) {
      _hasLoaded = false;
      debugPrintStack(stackTrace: s);
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> logout() async {
    final currentState = state;
    if (currentState is! ProfileUserState) return;

    emit(ProfileLoggingOut(currentState.user));

    try {
      await _authService.logout();
      await _clearSession();
      emit(const ProfileLoggedOut());
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      emit(
        ProfileActionError(
          user: currentState.user,
          message: 'something_went_wrong'.tr,
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    final currentState = state;
    if (currentState is! ProfileUserState) return;

    emit(ProfileDeletingAccount(currentState.user));

    try {
      await _authService.deleteAccount();
      await _clearSession();
      emit(const ProfileAccountDeleted());
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      emit(
        ProfileActionError(
          user: currentState.user,
          message: 'something_went_wrong'.tr,
        ),
      );
    }
  }

  Future<void> _clearSession() async {
    _userService.clearUser();
    await StorageService.remove(AppKeys.userId);
    _hasLoaded = false;
  }
}
