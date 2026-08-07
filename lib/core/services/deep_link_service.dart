import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../router/app_router.dart';

class DeepLinkService {
  DeepLinkService._();

  static final instance = DeepLinkService._();

  StreamSubscription<AuthState>? _subscription;

  void initialize() {
    _subscription ??= Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        final event = data.event;
        final session = data.session;

        if (event == AuthChangeEvent.passwordRecovery && session != null) {
          appRouter.go(AppRoutes.resetPassword);
        }
      },
      onError: (error) {
        appRouter.go(AppRoutes.login);
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}
