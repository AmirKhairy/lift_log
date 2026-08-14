import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'videos_state.dart';

class VideosCubit extends Cubit<VideosState> {
  VideosCubit() : super(const VideosInitial());

  bool _hasLoaded = false;
  Future<void>? _loadingFuture;

  Future<void> loadIfNeeded() {
    if (_hasLoaded) {
      return Future.value();
    }

    if (_loadingFuture != null) {
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
    emit(const VideosLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _hasLoaded = true;
      emit(const VideosLoaded());
    } catch (e, s) {
      _hasLoaded = false;
      debugPrintStack(stackTrace: s);
      emit(VideosError(e.toString()));
    }
  }
}
