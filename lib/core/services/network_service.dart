import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService extends ChangeNotifier {
  NetworkService._();

  static final instance = NetworkService._();

  StreamSubscription<InternetStatus>? _subscription;
  bool? _isConnected;
  bool _hasStarted = false;
  bool _isDisposed = false;

  bool? get isConnected => _isConnected;

  Future<void> start() async {
    if (_hasStarted || _isDisposed) return;

    _hasStarted = true;
    _subscription = InternetConnection().onStatusChange.listen(_setStatus);

    try {
      final isConnected = await InternetConnection().hasInternetAccess;
      _setStatus(
        isConnected ? InternetStatus.connected : InternetStatus.disconnected,
      );
    } catch (_) {
      _setStatus(InternetStatus.disconnected);
    }
  }

  void _setStatus(InternetStatus status) {
    final isConnected = status == InternetStatus.connected;

    if (_isConnected == isConnected || _isDisposed) return;

    _isConnected = isConnected;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
