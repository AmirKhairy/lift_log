import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/machines/cubit/machines_cubit.dart';

class MachinesEmptyView extends StatelessWidget {
  const MachinesEmptyView({super.key, required this.hasAnyMachines});

  final bool hasAnyMachines;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppPadding.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.precision_manufacturing_outlined,
              size: 64.sp,
              color: context.theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            SizedBox(height: AppSpacing.md),
            AppText(
              hasAnyMachines
                  ? 'no_machines_for_muscle_group'.tr
                  : 'no_machines'.tr,
              textAlign: TextAlign.center,
              fontSize: 16.sp,
              color: context.theme.colorScheme.onSurface,
            ),
            if (!hasAnyMachines) ...[
              SizedBox(height: AppSpacing.lg),
              AppButton(
                title: 'add_new_machine',
                onPressed: () => _openAddMachine(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openAddMachine(BuildContext context) async {
    final added = await context.push<Object>(AppRoutes.addMachine);
    if (!context.mounted) return;
    if (added != null) {
      await context.read<MachinesCubit>().refresh();
    }
  }
}
