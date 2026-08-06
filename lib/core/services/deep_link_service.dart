import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../router/app_router.dart';

class DeepLinkService {
  DeepLinkService._();

  static final instance = DeepLinkService._();

  StreamSubscription<AuthState>? _subscription;

  void initialize() {
    _subscription ??= Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      final event = data.event;
      final session = data.session;

      switch (event) {
        case AuthChangeEvent.passwordRecovery:
          if (session != null) {
            appRouter.go(AppRoutes.resetPassword);
          }
          break;

        default:
          break;
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
