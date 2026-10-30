import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/body_progress_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/body_progress/cubit/body_progress_state.dart';

import 'body_progress_section_card.dart';

class BodyProgressGoalCard extends StatelessWidget {
  const BodyProgressGoalCard({
    super.key,
    required this.state,
    required this.onSetGoal,
    required this.onRemoveGoal,
    this.isSaving = false,
    this.isDeleting = false,
  });
  final BodyProgressLoaded state;
  final ValueChanged<WeightGoal?> onSetGoal;
  final ValueChanged<String> onRemoveGoal;
  final bool isSaving;
  final bool isDeleting;
  @override
  Widget build(BuildContext context) {
    final goal = state.activeGoal;
    return BodyProgressSectionCard(
      title: 'weight_goal',
      goalAchieved:
          goal != null &&
          state.remainingWeight != null &&
          state.remainingWeight! <= 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (goal == null)
            AppText('no_weight_goal')
          else ...[
            AppText(
              '${'target_weight'.tr}: ${goal.targetWeight.toStringAsFixed(1)} ${'weight_unit'.tr}',
            ),
            if (state.remainingWeight != null)
              AppText(
                '${'remaining_weight'.tr}: ${state.remainingWeight!.abs().toStringAsFixed(1)} ${'weight_unit'.tr}',
              ),
            if (state.goalProgress != null) ...[
              SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(
                value: state.goalProgress!.clamp(0.0, 1.0).toDouble(),
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ],
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isSaving || isDeleting
                      ? null
                      : () => onSetGoal(goal),
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : AppText(goal == null ? 'set_goal' : 'change_goal'),
                ),
              ),
              if (goal != null)
                IconButton(
                  onPressed: isSaving || isDeleting
                      ? null
                      : () => onRemoveGoal(goal.id),
                  icon: isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
