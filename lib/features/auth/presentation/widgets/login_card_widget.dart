import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/helpers/validators.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_assets.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_labeled_text_field.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/features/auth/cubit/auth_state.dart';

class LoginCardWidget extends StatelessWidget {
  const LoginCardWidget({
    super.key,
    required this._formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> _formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.card,
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderGray, width: 1),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppStaggeredAnimation(
              index: 0,
              child: LabeledTextField(
                label: 'Email',
                child: AppTextField(
                  controller: emailController,
                  hint: 'name@example.com',
                  hintColor: AppColors.subtitleDark,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.white,
                  ),
                  filled: true,
                  fillColor: AppColors.gray,
                  validator: (value) => Validators.email(value),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            AppStaggeredAnimation(
              index: 1,
              child: LabeledTextField(
                label: 'Password',
                child: AppTextField(
                  controller: passwordController,
                  hint: '••••••••',
                  hintColor: AppColors.subtitleDark,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  obscureIconColor: AppColors.white,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.white,
                  ),
                  filled: true,
                  fillColor: AppColors.gray,
                  validator: (value) => Validators.password(value),
                ),
              ),
            ),
            AppStaggeredAnimation(
              index: 2,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  child: AppText(
                    'Forgot password?',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  onPressed: () {
                    context.push(AppRoutes.forgotPassword);
                  },
                ),
              ),
            ),
            AppStaggeredAnimation(
              index: 3,
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is EmailAuthSuccess) {
                    context.go(AppRoutes.home, extra: {'userId': state.userId});
                  }
                  if (state is EmailAuthFailure) {
                    AppSnackbar.error(message: state.message, context: context);
                  }
                },
                builder: (context, state) {
                  return AppButton(
                    title: 'Login',
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      context.read<AuthCubit>().loginWithEmailAndPassword(
                        formKey: _formKey,
                        email: email,
                        password: password,
                      );
                    },
                    loading: state is EmailAuthLoading,
                  );
                },
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            AppStaggeredAnimation(
              index: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.subtitleLight,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                  AppText(
                    'Or Continue with',
                    style: TextStyle(color: AppColors.subtitleDark),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.subtitleLight,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            AppStaggeredAnimation(
              index: 5,
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is GoogleAuthSuccess) {
                    context.go(AppRoutes.home, extra: {'userId': state.userId});
                  }
                  if (state is GoogleNewUserAuthSuccess) {
                    context.push(
                      AppRoutes.register,
                      extra: {
                        'userId': state.userId,
                        'userName': state.userName,
                        'userEmail': state.userEmail,
                      },
                    );
                    return;
                  }
                  if (state is GoogleAuthFailure) {
                    AppSnackbar.error(message: state.message, context: context);
                  }
                },
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppButton(
                          title: 'Google',
                          onPressed: () =>
                              context.read<AuthCubit>().loginWithGoogle(),
                          icon: Image.asset(AppAssets.google, width: 20),

                          backgroundColor: AppColors.gray,
                          loading: state is GoogleAuthLoading,
                        ),
                      ),
                    ],
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
