import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_text.dart';

import '../../cubit/home_cubit.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.xs,
      child: Row(
        children: [
          Container(
            padding: AppPadding.xs,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.colorScheme.surface,
              border: Border.all(
                color: context.theme.colorScheme.onSurface.withValues(
                  alpha: 0.2,
                ),
                width: 1.w,
              ),
            ),
            child: Icon(
              Icons.person,
              color: context.theme.colorScheme.primary,
              size: 40.sp,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText('welcome_back'.tr),
              SizedBox(height: AppSpacing.xs),
              AppText(
                context.read<HomeCubit>().userModel?.name ?? 'user'.tr,
                color: context.theme.colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
