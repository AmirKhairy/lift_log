import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/services/api_services/machines_service.dart';

import 'machines_state.dart';

class MachinesCubit extends Cubit<MachinesState> {
  MachinesCubit() : super(const MachinesInitial());

  final MachinesService machinesService = MachinesService.instance;

  bool _hasLoaded = false;
  Future<void>? _loadingFuture;
  List<MachineModel>? get machines => machinesService.machines;

  Future<void> loadIfNeeded() {
    if (_hasLoaded) {
      return Future.value();
    }

    if (_loadingFuture != null) {
      return _loadingFuture!;
    }

    final future = _loadMachine(isRefresh: false);
    _loadingFuture = future;
    return future.whenComplete(() => _loadingFuture = null);
  }

  Future<void> refresh() async {
    await _loadMachine(isRefresh: true);
  }

  Future<void> _loadMachine({required bool isRefresh}) async {
    emit(const MachinesLoding());

    try {
      await machinesService.getMachines();

      _hasLoaded = true;
      emit(const MachinesLoadedSuccess());
    } catch (e, s) {
      _hasLoaded = false;
      debugPrintStack(stackTrace: s);
      emit(MachinesError(e.toString()));
    }
  }
}
