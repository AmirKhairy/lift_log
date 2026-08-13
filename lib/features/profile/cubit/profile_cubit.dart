import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial());

  bool _hasLoaded = false;
  Future<void>? _loadingFuture;

  Future<void> loadIfNeeded() {
    if (_hasLoaded) {
      debugPrint('ProfileCubit: Profile data already loaded, skipping');
      return Future.value();
    }

    if (_loadingFuture != null) {
      debugPrint(
        'ProfileCubit: Profile load already in progress, skipping duplicate call',
      );
      return _loadingFuture!;
    }

    final future = _loadData(isRefresh: false);
    _loadingFuture = future;
    return future.whenComplete(() => _loadingFuture = null);
  }

  Future<void> refresh() async {
    await _loadData(isRefresh: true);
  }

  Future<void> _loadData({required bool isRefresh}) async {
    emit(const ProfileLoading());

    try {
      if (isRefresh) {
        debugPrint('ProfileCubit: Refreshing Profile data...');
      } else {
        debugPrint('ProfileCubit: Loading Profile data...');
      }

      await Future.delayed(const Duration(milliseconds: 500));

      _hasLoaded = true;
      emit(const ProfileLoaded());

      if (isRefresh) {
        debugPrint('ProfileCubit: Profile data refreshed');
      } else {
        debugPrint('ProfileCubit: Profile data loaded');
      }
    } catch (e, s) {
      _hasLoaded = false;
      debugPrint('ProfileCubit: Failed to load Profile data: $e');
      debugPrintStack(stackTrace: s);
      emit(ProfileError(e.toString()));
    }
  }
}
