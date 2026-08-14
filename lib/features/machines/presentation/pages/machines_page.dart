import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/machines/cubit/machines_cubit.dart';
import 'package:lift_log/features/machines/cubit/machines_state.dart';
import 'package:lift_log/features/machines/presentation/widgets/machine_item_widget.dart';
import 'package:lift_log/features/machines/presentation/widgets/machines_loading.dart';

class MachinesPage extends StatelessWidget {
  const MachinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppPadding.horizontal,
          child: AppText(
            'your_machines'.tr,
            color: context.theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: AppSpacing.nm),
        Expanded(
          child: BlocBuilder<MachinesCubit, MachinesState>(
            builder: (context, state) {
              return switch (state) {
                MachinesInitial() => AppText('machines_initial_state'.tr),
                MachinesLoding() => ListView.builder(
                  itemCount: 4,
                  itemBuilder: (_, index) {
                    return const MachineShimmer();
                  },
                ),
                MachinesLoadedSuccess() => ListView.builder(
                  itemCount: context.read<MachinesCubit>().machines?.length,
                  itemBuilder: (context, index) {
                    final machine = context
                        .read<MachinesCubit>()
                        .machines?[index];
                    return MachineItemWidget(machine: machine);
                  },
                ),
                MachinesError(:final message) => AppText(
                  '${'machines_error'.tr}: $message',
                ),
              };
            },
          ),
        ),
      ],
    );
  }
}
