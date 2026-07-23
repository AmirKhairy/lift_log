import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/features/onBoarding/presentation/pages/onboarding_page.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
  static const workout = '/workout';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) {
        return const Scaffold(body: Center(child: Text('Splash')));
      },
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) {
        return const OnboardingPage();
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return const Scaffold(body: Center(child: Text('Login')));
      },
    ),
  ],
);
