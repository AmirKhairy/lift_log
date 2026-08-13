import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit() : super(const ProgressInitial());

  bool _hasLoaded = false;
  Future<void>? _loadingFuture;

  Future<void> loadIfNeeded() {
    if (_hasLoaded) {
      debugPrint('ProgressCubit: Progress data already loaded, skipping');
      return Future.value();
    }

    if (_loadingFuture != null) {
      debugPrint(
        'ProgressCubit: Progress load already in progress, skipping duplicate call',
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
    emit(const ProgressLoading());

    try {
      if (isRefresh) {
        debugPrint('ProgressCubit: Refreshing Progress data...');
      } else {
        debugPrint('ProgressCubit: Loading Progress data...');
      }

      await Future.delayed(const Duration(milliseconds: 500));

      _hasLoaded = true;
      emit(const ProgressLoaded());

      if (isRefresh) {
        debugPrint('ProgressCubit: Progress data refreshed');
      } else {
        debugPrint('ProgressCubit: Progress data loaded');
      }
    } catch (e, s) {
      _hasLoaded = false;
      debugPrint('ProgressCubit: Failed to load Progress data: $e');
      debugPrintStack(stackTrace: s);
      emit(ProgressError(e.toString()));
    }
  }
}
