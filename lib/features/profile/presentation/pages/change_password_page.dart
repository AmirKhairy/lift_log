import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/helpers/validators.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_labeled_text_field.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';
import 'package:lift_log/features/profile/cubit/change_password_cubit.dart';
import 'package:lift_log/features/profile/cubit/change_password_state.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            AppSnackbar.success(
              message: 'password_changed'.tr,
              context: context,
            );
            context.pop();
          }

          if (state is ChangePasswordFailure) {
            AppSnackbar.error(message: state.message, context: context);
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangePasswordLoading;

          return AppScaffold(
            appBar: AppBar(title: Text('change_password'.tr)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    LabeledTextField(
                      label: 'new_password'.tr,
                      child: AppTextField(
                        controller: _passwordController,
                        hint: '••••••••',
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: context.theme.colorScheme.onSurface,
                        ),
                        validator: (value) =>
                            Validators.password(value, skip: false),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    LabeledTextField(
                      label: 'confirm_password'.tr,
                      child: AppTextField(
                        controller: _confirmPasswordController,
                        hint: '••••••••',
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: context.theme.colorScheme.onSurface,
                        ),
                        validator: (value) => Validators.confirmPassword(
                          value,
                          _passwordController.text.trim(),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),
                    AppButton(
                      title: 'save',
                      loading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () => context
                                .read<ChangePasswordCubit>()
                                .changePassword(
                                  password: _passwordController.text.trim(),
                                  formKey: _formKey,
                                ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
