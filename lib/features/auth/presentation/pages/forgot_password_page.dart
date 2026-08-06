import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/helpers/validators.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_labeled_text_field.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/features/auth/cubit/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppStaggeredAnimation(
                index: 0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Icon(
                    Icons.lock_reset_outlined,
                    size: 40,
                    color: AppColors.surfaceDark,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              AppStaggeredAnimation(
                index: 1,
                child: Column(
                  children: [
                    AppText(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    AppText(
                      'Enter your email address below and we\'ll send you a link to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.subtitleLight,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              AppStaggeredAnimation(
                index: 2,
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
              SizedBox(height: AppSpacing.lg),
              AppStaggeredAnimation(
                index: 3,
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is ResetPasswordEmailSuccess) {
                      AppSnackbar.success(
                        message:
                            'Password reset email sent successfully, Please check your inbox.',
                        context: context,
                      );
                    }
                    if (state is ResetPasswordEmailFailure) {
                      AppSnackbar.error(
                        message: state.message,
                        context: context,
                      );
                    }
                  },
                  builder: (context, state) {
                    return AppButton(
                      title: 'Send Reset Link',
                      onPressed: () {
                        final email = emailController.text.trim();
                        context.read<AuthCubit>().sendResetPasswordEmail(
                          formKey: _formKey,
                          email: email,
                        );
                      },
                      loading: state is ResetPasswordEmailLoading,
                    );
                  },
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              AppStaggeredAnimation(
                index: 4,
                child: TextButton(
                  child: AppText(
                    'Back to Login',
                    style: TextStyle(color: AppColors.secondary),
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
