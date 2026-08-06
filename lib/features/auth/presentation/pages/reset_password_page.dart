import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/helpers/validators.dart';
import 'package:lift_log/core/router/app_router.dart';
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

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final TextEditingController newPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
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
                      'reset_password'.tr,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    AppText(
                      'reset_password_instructions'.tr,
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
                  label: 'new_password'.tr,
                  child: AppTextField(
                    controller: newPasswordController,
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
              SizedBox(height: AppSpacing.lg),
              AppStaggeredAnimation(
                index: 3,
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is ResetPasswordSuccess) {
                      AppSnackbar.success(
                        message: 'reset_password_success'.tr,
                        context: context,
                      );
                      Future.delayed(const Duration(seconds: 2));
                      context.go(AppRoutes.login);
                    }
                    if (state is ResetPasswordFailure) {
                      AppSnackbar.error(
                        message: state.message,
                        context: context,
                      );
                    }
                  },
                  builder: (context, state) {
                    return AppButton(
                      title: 'reset_password'.tr,
                      onPressed: () {
                        final password = newPasswordController.text.trim();
                        context.read<AuthCubit>().updatePassword(
                          formKey: _formKey,
                          password: password,
                        );
                      },
                      loading: state is ResetPasswordLoading,
                    );
                  },
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              AppStaggeredAnimation(
                index: 4,
                child: TextButton(
                  child: AppText(
                    'back_to_login'.tr,
                    style: TextStyle(color: AppColors.secondary),
                  ),
                  onPressed: () {
                    context.go(AppRoutes.login);
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
