import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_assets.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/auth/presentation/widgets/regester_card_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, this.userName, this.userEmail, this.userId});
  final String? userId;
  final String? userName;
  final String? userEmail;
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final String userIdFromGoogle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userIdFromGoogle = widget.userId ?? '';
    emailController = TextEditingController(text: widget.userEmail ?? '');
    passwordController = TextEditingController();
    nameController = TextEditingController(text: widget.userName ?? '');
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

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
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  AppText(
                    'Start your journey to peak performance today.',
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
              child: RegesterCardWidget(
                formKey: _formKey,
                nameController: nameController,
                emailController: emailController,
                passwordController: passwordController,
                userIdFromGoogle: userIdFromGoogle,
              ),
            ),
            AppStaggeredAnimation(
              index: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    'Already have an account?',
                    style: TextStyle(color: AppColors.subtitleDark),
                  ),
                  TextButton(
                    child: AppText(
                      'Login',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    onPressed: () {
                      context.pop();
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
