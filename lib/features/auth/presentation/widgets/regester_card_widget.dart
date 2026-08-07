import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/features/auth/cubit/auth_state.dart';
import 'package:lift_log/features/auth/presentation/widgets/regester_card_account_details_section.dart';
import 'package:lift_log/features/auth/presentation/widgets/regester_card_physical_section.dart';
import 'package:lift_log/features/auth/presentation/widgets/regester_card_section_title.dart';

class RegesterCardWidget extends StatelessWidget {
  const RegesterCardWidget({
    super.key,
    required this._formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.userIdFromGoogle,
  });

  final GlobalKey<FormState> _formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String userIdFromGoogle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.card,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.appColors.border, width: 1),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppStaggeredAnimation(
              index: 0,
              child: RegesterCardSectionTitle(title: 'account_details'.tr),
            ),
            SizedBox(height: AppSpacing.md),

            RegesterCardAccountDetailsSection(
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              userIdFromGoogle: userIdFromGoogle,
            ),
            SizedBox(height: AppSpacing.md),
            AppStaggeredAnimation(
              index: 4,
              child: RegesterCardSectionTitle(title: 'physical_details'.tr),
            ),
            SizedBox(height: AppSpacing.md),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return RegesterCardPhysicalSection();
              },
            ),

            SizedBox(height: AppSpacing.lg),
            AppStaggeredAnimation(
              index: 7,
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is RegisterAuthSuccess) {
                    AppSnackbar.success(
                      message: 'registration_success'.tr,
                      context: context,
                    );
                    context.go(AppRoutes.home, extra: {'userId': state.userId});
                  }
                  if (state is GoogleRegisterAuthSuccess) {
                    AppSnackbar.success(
                      message: 'registration_success'.tr,
                      context: context,
                    );
                    context.go(AppRoutes.home, extra: {'userId': state.userId});
                  }
                  if (state is RegisterAuthFailure ||
                      state is GoogleRegisterAuthFailure) {
                    AppSnackbar.error(
                      message: state is GoogleRegisterAuthFailure
                          ? state.message
                          : (state is RegisterAuthFailure ? state.message : ''),
                      context: context,
                    );
                  }
                },
                builder: (context, state) {
                  return AppButton(
                    title: 'sign_up'.tr,
                    onPressed: () {
                      if (userIdFromGoogle.isNotEmpty) {
                        context.read<AuthCubit>().registerWithGoogle(
                          userId: userIdFromGoogle,
                          formKey: _formKey,
                        );
                      } else {
                        context.read<AuthCubit>().registerWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          name: nameController.text.trim(),
                          formKey: _formKey,
                        );
                      }
                    },
                    loading: state is RegisterAuthLoading,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
