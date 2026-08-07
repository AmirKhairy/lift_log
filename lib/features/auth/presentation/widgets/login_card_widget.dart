import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/helpers/validators.dart';
import 'package:lift_log/core/router/app_router.dart';
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
              child: LabeledTextField(
                label: 'email'.tr,
                child: AppTextField(
                  controller: emailController,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  validator: (value) => Validators.email(value),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            AppStaggeredAnimation(
              index: 1,
              child: LabeledTextField(
                label: 'password'.tr,
                child: AppTextField(
                  controller: passwordController,
                  hint: '••••••••',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: context.theme.colorScheme.onSurface,
                  ),
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
                    'forgot_password'.tr,
                    style: TextStyle(color: context.theme.colorScheme.primary),
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
                    title: 'login'.tr,
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
                      color: context.theme.dividerColor,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                  AppText(
                    'or_continue_with'.tr,
                    style: TextStyle(color: context.appColors.subtitle),
                  ),
                  Expanded(
                    child: Divider(
                      color: context.theme.dividerColor,
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
                          title: 'google'.tr,
                          textColor: context.theme.colorScheme.onSurface,
                          onPressed: () =>
                              context.read<AuthCubit>().loginWithGoogle(),
                          icon: Image.asset(AppAssets.google, width: 20),
                          backgroundColor:
                              context.theme.inputDecorationTheme.fillColor,
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
