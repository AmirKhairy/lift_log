import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/machine_model.dart';
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
import 'package:lift_log/features/machine_details/presentation/widgets/machine_details_delete_dialog.dart';
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
            MachineDetailsContentState(
              :final machine,
              :final tutorial,
              :final history,
              :final tutorialError,
              :final historyError,
            ) =>
              AppScaffold(
                title: machine.name ?? 'machine_details',
                loading: state is MachineDetailsDeleting,
                actions: [
                  IconButton(
                    tooltip: 'edit_machine'.tr,
                    onPressed: () async {
                      final cubit = context.read<MachineDetailsCubit>();
                      final didEdit = await cubit.editMachine(
                        openEditor: (machine) => context.push<MachineModel>(
                          AppRoutes.addMachine,
                          extra: machine,
                        ),
                      );

                      if (!context.mounted || !didEdit) return;
                      AppSnackbar.success(
                        message: 'machine_updated',
                        context: context,
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'delete_machine'.tr,
                    onPressed: () async {
                      final confirmed = await showMachineDetailsDeleteDialog(
                        context: context,
                      );
                      if (!context.mounted || confirmed != true) return;

                      await context.read<MachineDetailsCubit>().deleteMachine();
                    },
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
                                onTap: () {
                                  final opened = context
                                      .read<MachineDetailsCubit>()
                                      .openTutorial(
                                        tutorial: tutorial,
                                        openPlayer: (tutorial) => context.push(
                                          AppRoutes.tutorialVideoPlayer,
                                          extra: tutorial,
                                        ),
                                      );

                                  if (!opened) {
                                    AppSnackbar.error(
                                      message: 'video_link_not_available',
                                      context: context,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                          SizedBox(height: AppSpacing.lg),
                          AppStaggeredAnimation(
                            index: 3,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.history_rounded,
                                  color: context.theme.colorScheme.primary,
                                  size: 22.sp,
                                ),
                                SizedBox(width: AppSpacing.sm.w),
                                AppText(
                                  'machine_history',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp,
                                ),
                              ],
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
                        onPressed: () async {
                          final saved = await context.push<bool>(
                            AppRoutes.workout,
                            extra: machine,
                          );
                          if (saved == true && context.mounted) {
                            await context.read<MachineDetailsCubit>().load();
                          }
                        },
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
}
