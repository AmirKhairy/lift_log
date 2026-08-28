import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/machine_details/cubit/machine_details_cubit.dart';
import 'package:lift_log/features/machine_details/cubit/machine_details_state.dart';
import 'package:lift_log/features/machine_details/presentation/widgets/machine_details_header.dart';
import 'package:lift_log/features/machine_details/presentation/widgets/machine_details_history_section.dart';
import 'package:lift_log/features/machine_details/presentation/widgets/machine_details_tutorial_card.dart';

class MachineDetailsView extends StatelessWidget {
  const MachineDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final cubit = context.read<MachineDetailsCubit>();
        if (cubit.state is MachineDetailsDeleted) return;
        context.pop(cubit.didMutate ? true : null);
      },
      child: BlocConsumer<MachineDetailsCubit, MachineDetailsState>(
        listener: (context, state) {
          if (state is MachineDetailsDeleted) {
            context.pop(true);
          }

          if (state is MachineDetailsError) {
            AppSnackbar.error(message: state.message, context: context);
          }
        },
        builder: (context, state) {
          return switch (state) {
            MachineDetailsInitial() || MachineDetailsLoading() => AppScaffold(
              title: 'machine_details',
              body: const Center(child: CircularProgressIndicator()),
            ),
            MachineDetailsError() => AppScaffold(
              title: 'machine_details',
              body: Center(
                child: AppButton(
                  title: 'retry',
                  icon: const Icon(Icons.refresh),
                  onPressed: context.read<MachineDetailsCubit>().load,
                ),
              ),
            ),
            MachineDetailsDeleted() => AppScaffold(
              title: 'machine_details',
              body: const SizedBox.shrink(),
            ),
            MachineDetailsLoaded(
              :final machine,
              :final tutorial,
              :final history,
              :final tutorialError,
              :final historyError,
              :final isDeleting,
            ) =>
              AppScaffold(
                title: machine.name ?? 'machine_details',
                loading: isDeleting,
                actions: [
                  IconButton(
                    tooltip: 'edit_machine'.tr,
                    onPressed: () => _editMachine(context, machine),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'delete_machine'.tr,
                    onPressed: () => _confirmDelete(context),
                    icon: Icon(
                      Icons.delete_outline,
                      color: context.theme.colorScheme.error,
                    ),
                  ),
                ],
                body: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          AppStaggeredAnimation(
                            index: 0,
                            child: MachineDetailsHeader(machine: machine),
                          ),
                          if (machine.tutorialVideoId != null &&
                              machine.tutorialVideoId!.isNotEmpty) ...[
                            SizedBox(height: AppSpacing.lg),
                            AppStaggeredAnimation(
                              index: 1,
                              child: AppText(
                                'machine_tutorial',
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm),
                            AppStaggeredAnimation(
                              index: 2,
                              child: MachineDetailsTutorialCard(
                                tutorial: tutorial,
                                error: tutorialError,
                                onTap: () => _openTutorial(context, tutorial),
                              ),
                            ),
                          ],
                          SizedBox(height: AppSpacing.lg),
                          AppStaggeredAnimation(
                            index: 3,
                            child: AppText(
                              'machine_history',
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          AppStaggeredAnimation(
                            index: 4,
                            child: MachineDetailsHistorySection(
                              history: history,
                              error: historyError,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppStaggeredAnimation(
                      index: 5,
                      child: AppButton(
                        title: 'log_this_machine',
                        icon: Icon(Icons.add_chart, size: 24.sp),
                        onPressed: () =>
                            context.push(AppRoutes.workout, extra: machine),
                      ),
                    ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }

  Future<void> _editMachine(BuildContext context, MachineModel machine) async {
    final updated = await context.push<MachineModel>(
      AppRoutes.addMachine,
      extra: machine,
    );

    if (!context.mounted || updated == null) return;

    await context.read<MachineDetailsCubit>().replaceMachine(updated);
    if (!context.mounted) return;
    AppSnackbar.success(message: 'machine_updated', context: context);
  }

  void _openTutorial(BuildContext context, TutorialVideosModel? tutorial) {
    if (tutorial == null || (tutorial.videoUrl?.trim().isEmpty ?? true)) {
      AppSnackbar.error(message: 'video_link_not_available', context: context);
      return;
    }

    context.push(AppRoutes.tutorialVideoPlayer, extra: tutorial);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: AppText(
            'delete_machine',
            color: context.theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
          content: AppText(
            'delete_machine_confirmation',
            color: context.theme.colorScheme.onSurface,
            fontSize: 16.sp,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: AppText(
                'cancel',
                color: context.theme.colorScheme.primary,
                fontSize: 16.sp,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: AppText(
                'delete',
                color: context.theme.colorScheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted || confirmed != true) return;

    await context.read<MachineDetailsCubit>().deleteMachine();
  }
}
