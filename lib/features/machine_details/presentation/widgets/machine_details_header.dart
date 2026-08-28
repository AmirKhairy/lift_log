import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class MachineDetailsHeader extends StatelessWidget {
  const MachineDetailsHeader({super.key, required this.machine});

  final MachineModel machine;

  @override
  Widget build(BuildContext context) {
    final notes = machine.notes?.trim();
    final muscleGroup = machine.muscleGroup?.displayName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.nm),
          child: ColoredBox(
            color: context.theme.colorScheme.surfaceContainerHighest,
            child: AppCachedNetworkImage(
              imageUrl: machine.imageUrl ?? '',
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
        if (muscleGroup != null && muscleGroup.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppText(
                '${"muscle_group".tr}: ',
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
              SizedBox(width: AppSpacing.xs),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md.w,
                  vertical: AppSpacing.xs.h,
                ),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.nm),
                ),
                child: AppText(
                  muscleGroup,
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
        if (notes != null && notes.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          AppCard(
            padding: EdgeInsets.all(AppSpacing.md.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'description',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
                SizedBox(height: AppSpacing.xs),
                AppText(
                  notes,
                  fontSize: 14.sp,
                  color: context.appColors.subtitle,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
