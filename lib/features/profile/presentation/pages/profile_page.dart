import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/loading.dart';
import 'package:lift_log/features/home/cubit/home_cubit.dart';
import 'package:lift_log/features/profile/cubit/profile_cubit.dart';
import 'package:lift_log/features/profile/cubit/profile_state.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_confirmation_dialog.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_danger_section.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_data_section.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_settings_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          current is ProfileLoggedOut ||
          current is ProfileAccountDeleted ||
          (current is ProfileLoaded && current.actionError != null),
      listener: (context, state) {
        if (state is ProfileLoggedOut || state is ProfileAccountDeleted) {
          context.go(AppRoutes.login);
          return;
        }

        if (state is ProfileLoaded && state.actionError != null) {
          AppSnackbar.error(message: state.actionError!, context: context);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppPadding.horizontal,
              child: AppText(
                'profile_settings'.tr,
                color: context.theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: AppSpacing.nm),
            Expanded(child: _buildBody(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    return switch (state) {
      ProfileInitial() => const Center(
        child: Loading(),
      ),
      ProfileLoading() => const Center(child: Loading()),
      ProfileLoaded(:final user, :final isLoggingOut, :final isDeletingAccount) =>
        RefreshIndicator(
          onRefresh: () => context.read<ProfileCubit>().refresh(),
          child: ListView(
            padding: EdgeInsets.only(bottom: AppSpacing.xl),
            children: [
              ProfileDataSection(
                user: user,
                onEditProfile: () async {
                  final updated = await context.push<bool>(
                    AppRoutes.editProfile,
                    extra: user,
                  );

                  if (!context.mounted) return;

                  if (updated == true) {
                    await context.read<ProfileCubit>().refresh();
                    if (context.mounted) {
                      await context.read<HomeCubit>().refresh();
                    }
                  }
                },
                onChangePassword: () {
                  context.push(AppRoutes.changePassword);
                },
              ),
              SizedBox(height: AppSpacing.md),
              const ProfileSettingsSection(),
              SizedBox(height: AppSpacing.md),
              ProfileDangerSection(
                isLoggingOut: isLoggingOut,
                isDeletingAccount: isDeletingAccount,
                onLogout: () => _confirmLogout(context),
                onDeleteAccount: () => _confirmDeleteAccount(context),
              ),
            ],
          ),
        ),
      ProfileError(:final message) => Center(
        child: Padding(
          padding: AppPadding.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                'profile_error'.tr,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: context.theme.colorScheme.onSurface,
              ),
              SizedBox(height: AppSpacing.sm),
              AppText(
                message,
                textAlign: TextAlign.center,
                color: context.appColors.subtitle,
              ),
              SizedBox(height: AppSpacing.md),
              AppButton(
                title: 'retry',
                width: 160,
                onPressed: () => context.read<ProfileCubit>().refresh(),
              ),
            ],
          ),
        ),
      ),
      ProfileLoggedOut() || ProfileAccountDeleted() => const SizedBox.shrink(),
    };
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showProfileConfirmationDialog(
      context: context,
      titleKey: 'logout',
      messageKey: 'logout_confirmation',
      confirmKey: 'logout',
    );

    if (confirmed == true && context.mounted) {
      await context.read<ProfileCubit>().logout();
    }
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await showProfileConfirmationDialog(
      context: context,
      titleKey: 'delete_account',
      messageKey: 'delete_account_confirmation',
      confirmKey: 'delete',
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      await context.read<ProfileCubit>().deleteAccount();
    }
  }
}
