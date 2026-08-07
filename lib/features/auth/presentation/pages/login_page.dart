import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/router/app_router.dart';
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
      backgroundColor: context.theme.scaffoldBackgroundColor,
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
                    'lift_log'.tr,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  AppText(
                    'welcome_back'.tr,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.appColors.subtitle,
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
                    'dont_have_account'.tr,
                    style: TextStyle(color: context.appColors.subtitle),
                  ),
                  TextButton(
                    child: AppText(
                      'sign_up'.tr,
                      style: TextStyle(
                        color: context.theme.colorScheme.primary,
                      ),
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
