import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/features/home/presentation/widgets/stat_card.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({
    super.key,
    required this.gymCount,
    required this.machineCount,
  });

  final int gymCount;
  final int machineCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal,
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.fitness_center,
              value: gymCount.toString(),
              label: 'gyms'.tr,
            ),
          ),

          SizedBox(width: AppSpacing.sm),

          Expanded(
            child: StatCard(
              icon: Icons.precision_manufacturing,
              value: machineCount.toString(),
              label: 'machines'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
