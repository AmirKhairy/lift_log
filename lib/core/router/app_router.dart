import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/constants/app_keys.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/models/user_model.dart';
import 'package:lift_log/core/services/storage_service.dart';
import 'package:lift_log/features/add_machine/presentation/pages/add_machine_page.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:lift_log/features/auth/presentation/pages/login_page.dart';
import 'package:lift_log/features/auth/presentation/pages/reset_password_page.dart';
import 'package:lift_log/features/auth/presentation/pages/sign_up_page.dart';
import 'package:lift_log/features/machine_details/presentation/pages/machine_details_page.dart';
import 'package:lift_log/features/main/presentation/pages/main_page.dart';
import 'package:lift_log/features/onBoarding/presentation/pages/onboarding_page.dart';
import 'package:lift_log/features/profile/presentation/pages/change_password_page.dart';
import 'package:lift_log/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:lift_log/features/timer/cubit/timer_cubit.dart';
import 'package:lift_log/features/timer/presentation/pages/timer_page.dart';
import 'package:lift_log/features/tutorial_video_player/presentation/pages/tutorial_video_player_page.dart';
import 'package:lift_log/features/workout/presentation/pages/workout_page.dart';
import 'package:lift_log/features/workout_history/presentation/pages/workout_history_page.dart';

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
  static const editProfile = '/edit-profile';
  static const changePassword = '/change-password';
  static const workout = '/workout';
  static const workoutHistory = '/workout-history';
  static const addMachine = '/add-machine';
  static const machineDetails = '/machine-details';
  static const tutorialVideoPlayer = '/tutorial-video-player';
  static const timer = '/timer';
}

bool get _isOnboardingCompleted =>
    StorageService.getBool(AppKeys.onboardingCompleted) ?? false;

bool get _hasSavedUserId {
  final userId = StorageService.getString(AppKeys.userId);
  return userId != null && userId.isNotEmpty;
}

String _resolveInitialLocation() {
  if (!_isOnboardingCompleted) {
    return AppRoutes.onboarding;
  }

  if (_hasSavedUserId) {
    return AppRoutes.home;
  }

  return AppRoutes.login;
}

final GoRouter appRouter = GoRouter(
  initialLocation: _resolveInitialLocation(),
  redirect: (context, state) {
    final uri = state.uri;
    final location = state.matchedLocation;

    if (!_isOnboardingCompleted && location != AppRoutes.onboarding) {
      return AppRoutes.onboarding;
    }

    if (_isOnboardingCompleted && location == AppRoutes.onboarding) {
      return _hasSavedUserId ? AppRoutes.home : AppRoutes.login;
    }

    if (_hasSavedUserId &&
        (location == AppRoutes.login || location == AppRoutes.register)) {
      return AppRoutes.home;
    }

    if (!_hasSavedUserId && location == AppRoutes.home) {
      return AppRoutes.login;
    }

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
        GoRoute(path: AppRoutes.home, builder: (_, _) => const MainPage()),
        GoRoute(
          path: AppRoutes.workout,
          builder: (_, state) => WorkoutPage(
            initialMachine: state.extra is MachineModel
                ? state.extra as MachineModel
                : null,
          ),
        ),
        GoRoute(
          path: AppRoutes.workoutHistory,
          builder: (_, _) => const WorkoutHistoryPage(),
        ),
        GoRoute(
          path: AppRoutes.addMachine,
          builder: (_, state) => AddMachinePage(
            machineToEdit: state.extra is MachineModel
                ? state.extra as MachineModel
                : null,
          ),
        ),
        GoRoute(
          path: AppRoutes.machineDetails,
          builder: (context, state) {
            final machine = state.extra as MachineModel;
            return MachineDetailsPage(machine: machine);
          },
        ),
        GoRoute(
          path: AppRoutes.tutorialVideoPlayer,
          builder: (context, state) {
            final extra = state.extra;
            final video = extra is Map<String, dynamic>
                ? extra['video'] as TutorialVideosModel
                : extra as TutorialVideosModel;
            final relatedVideos = extra is Map<String, dynamic>
                ? (extra['relatedVideos'] as List<TutorialVideosModel>?) ?? []
                : const <TutorialVideosModel>[];

            return TutorialVideoPlayerPage(
              video: video,
              relatedVideos: relatedVideos,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) {
            final user = state.extra as UserModel;
            return EditProfilePage(user: user);
          },
        ),
        GoRoute(
          path: AppRoutes.changePassword,
          builder: (_, _) => const ChangePasswordPage(),
        ),
        GoRoute(
          path: AppRoutes.timer,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => TimerCubit(),
              child: const TimerPage(),
            );
          },
        ),
      ],
    ),
  ],
);
