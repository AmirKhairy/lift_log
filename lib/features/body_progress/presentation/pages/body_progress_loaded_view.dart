import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/features/body_progress/cubit/body_progress_cubit.dart';
import 'package:lift_log/features/body_progress/cubit/body_progress_state.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_bmi_card.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_chart.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_empty_card.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_goal_card.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_goal_dialog.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_history_card.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_metric_card.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_period_changes_card.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_period_selector.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_section_card.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_statistics_card.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_weight_dialog.dart';

class BodyProgressLoadedView extends StatelessWidget {
  const BodyProgressLoadedView({super.key, required this.state});
  final BodyProgressLoaded state;

  @override
  Widget build(BuildContext context) {
    final stats = state.stats;
    final cubit = context.read<BodyProgressCubit>();
    final isSaving = state is BodyProgressSaving;
    final deletingId = state is BodyProgressDeleting
        ? (state as BodyProgressDeleting).deletingId
        : null;
    final isGoalSaving = state is BodyProgressGoalSaving;
    final isGoalDeleting = state is BodyProgressGoalDeleting;
    return RefreshIndicator(
      onRefresh: cubit.load,
      child: ListView(
        padding: AppPadding.horizontal,
        children: [
          Row(
            children: [
              Expanded(
                child: BodyProgressMetricCard(
                  label: 'current_weight',
                  value: stats.currentWeight,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: BodyProgressMetricCard(
                  label: 'total_change',
                  value: stats.totalChange,
                  signed: true,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          AppButton(
            title: 'add_weight',
            loading: isSaving,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => BodyProgressWeightDialog(onSave: cubit.addWeight),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          if (state.entries.isEmpty)
            const BodyProgressEmptyCard()
          else ...[
            BodyProgressSectionCard(
              title: 'weight_chart',
              child: BodyProgressChart(
                entries: stats.selectedEntries,
                weightUnit: 'weight_unit'.tr,
                locale: Localizations.localeOf(context).toLanguageTag(),
                semanticLabel: 'weight_chart'.tr,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            BodyProgressPeriodSelector(
              selectedDays: state.selectedDays,
              onSelected: cubit.selectPeriod,
            ),
            SizedBox(height: AppSpacing.md),
            BodyProgressPeriodChangesCard(stats: stats),
            SizedBox(height: AppSpacing.md),
            BodyProgressStatisticsCard(stats: stats),
          ],
          SizedBox(height: AppSpacing.md),
          BodyProgressBmiCard(stats: stats),
          SizedBox(height: AppSpacing.md),
          BodyProgressGoalCard(
            state: state,
            isSaving: isGoalSaving,
            isDeleting: isGoalDeleting,
            onSetGoal: (goal) => showDialog<void>(
              context: context,
              builder: (_) =>
                  BodyProgressGoalDialog(goal: goal, onSave: cubit.setGoal),
            ),
            onRemoveGoal: cubit.removeGoal,
          ),
          if (state.entries.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            BodyProgressHistoryCard(
              entries: state.entries,
              currentEntryId: state.currentEntry?.id,
              deletingId: deletingId,
              isSaving: isSaving,
              onEdit: (entry) => showDialog<void>(
                context: context,
                builder: (_) => BodyProgressWeightDialog(
                  entry: entry,
                  onSave: (weight, date) =>
                      cubit.updateWeight(entry.id, weight, date),
                ),
              ),
              onDelete: cubit.deleteWeight,
            ),
          ],
        ],
      ),
    );
  }
}
