import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:lift_log/features/auth/presentation/pages/login_page.dart';
import 'package:lift_log/features/auth/presentation/pages/reset_password_page.dart';
import 'package:lift_log/features/auth/presentation/pages/sign_up_page.dart';
import 'package:lift_log/features/home/presentation/pages/home_page.dart';
import 'package:lift_log/features/onBoarding/presentation/pages/onboarding_page.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
  static const workout = '/workout';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  redirect: (context, state) {
    final uri = state.uri;

    if (uri.scheme == 'liftlog' && uri.host == 'reset-password') {
      return AppRoutes.login;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) {
        return const OnboardingPage();
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(create: (_) => AuthCubit(), child: child);
      },
      routes: [
        GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return SignUpPage(
              userId: extra?['userId'],
              userName: extra?['userName'],
              userEmail: extra?['userEmail'],
            );
          },
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (_, _) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          builder: (_, _) => const ResetPasswordPage(),
        ),
        GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
      ],
    ),
  ],
);
