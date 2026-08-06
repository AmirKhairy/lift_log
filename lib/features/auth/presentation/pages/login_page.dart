import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_assets.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/auth/presentation/widgets/login_card_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            AppStaggeredAnimation(
              index: 0,
              child: Image.asset(
                AppAssets.logo,
                fit: BoxFit.contain,
                height: 20,
                width: 20,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            AppStaggeredAnimation(
              index: 1,
              child: Column(
                children: [
                  AppText(
                    'LiftLog',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  AppText(
                    'welcome back',
                    style: TextStyle(
                      fontSize: 24,
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
              child: LoginCardWidget(
                formKey: _formKey,
                emailController: emailController,
                passwordController: passwordController,
              ),
            ),
            AppStaggeredAnimation(
              index: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    'Don\'t have an account? ',
                    style: TextStyle(color: AppColors.subtitleDark),
                  ),
                  TextButton(
                    child: AppText(
                      'Sign up',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    onPressed: () {
                      context.push(AppRoutes.register);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
