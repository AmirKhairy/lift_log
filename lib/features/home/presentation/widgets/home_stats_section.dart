import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/features/home/presentation/widgets/stat_card.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({
    super.key,
    required this.machineCount,
    required this.animation,
    required this.onAddWorkout,
  });

  final int machineCount;
  final Animation<double> animation;
  final VoidCallback onAddWorkout;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal,
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.precision_manufacturing,
              value: machineCount.toString(),
              label: 'machines'.tr,
              animation: animation,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: InkWell(
              onTap: onAddWorkout,
              child: StatCard(
                icon: Icons.fitness_center,
                value: 'add_new_workout'.tr,
                animation: animation,
                backgroundColor: context.theme.colorScheme.primary,
                iconColor: context.theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
