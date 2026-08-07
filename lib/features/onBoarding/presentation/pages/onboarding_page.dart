import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/widgets/app_text.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_padding.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../cubit/onboarding_cubit.dart';
import '../../cubit/onboarding_states.dart';
import '../../models/onboarding_item.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listenWhen: (previous, current) =>
            previous.currentIndex != current.currentIndex ||
            previous.isCompleted != current.isCompleted,
        listener: (context, state) {
          if (state.isCompleted) {
            context.go(AppRoutes.login);
            return;
          }

          if (_pageController.hasClients) {
            _pageController.animateToPage(
              state.currentIndex,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
            );
          }
        },
        builder: (context, state) {
          final items = onboardingItems();
          final currentItem = items[state.currentIndex];
          final isLastPage = state.currentIndex == items.length - 1;

          return AppScaffold(
            backgroundColor: context.theme.scaffoldBackgroundColor,

            padding: EdgeInsets.zero,
            body: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: items.length,
                    onPageChanged: context.read<OnboardingCubit>().pageChanged,
                    itemBuilder: (context, index) {
                      return OnboardingContent(item: items[index]);
                    },
                  ),
                ),
                OnboardingIndicator(
                  length: items.length,
                  currentIndex: state.currentIndex,
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: AppPadding.horizontal,
                  child: AppButton(
                    title: currentItem.buttonText,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    onPressed: context.read<OnboardingCubit>().nextPressed,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: context.read<OnboardingCubit>().complete,
                  child: AppText(
                    isLastPage ? 'already_have_an_account_login'.tr : 'skip'.tr,
                    style: TextStyle(color: context.appColors.subtitle),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          );
        },
      ),
    );
  }
}
