import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class MachineItemWidget extends StatelessWidget {
  const MachineItemWidget({super.key, required this.machine});

  final MachineModel? machine;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(AppRoutes.machineDetails, extra: machine);
      },
      child: Container(
        padding: AppPadding.xs,
        margin: AppPadding.xs,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          color: context.theme.colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: AppCachedNetworkImage(
                imageUrl: machine?.imageUrl ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
            ),
            SizedBox(height: AppSpacing.sm),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  '${'machine_name'.tr}:',
                  color: context.theme.colorScheme.onSurface,
                  fontWeight: FontWeight.normal,
                  fontSize: 20.sp,
                ),
                SizedBox(width: AppSpacing.sm),
                AppText(
                  machine?.name ?? '',
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  '${'muscle_group'.tr}:',
                  color: context.theme.colorScheme.onSurface,
                  fontWeight: FontWeight.normal,
                  fontSize: 20.sp,
                ),
                SizedBox(width: AppSpacing.sm),
                AppText(
                  machine?.muscleGroup?.displayName ?? '',
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
