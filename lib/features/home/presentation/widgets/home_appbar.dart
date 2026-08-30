import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_text.dart';

import '../../cubit/home_cubit.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final progress = (scrollController.offset / 100).clamp(0.0, 1.0);

        final avatarSize = lerpDouble(40.sp, 32.sp, progress)!;

        final horizontalSpacing = lerpDouble(
          AppSpacing.sm,
          AppSpacing.xs,
          progress,
        )!;

        return Padding(
          padding: AppPadding.xs,
          child: Row(
            children: [
              Transform.scale(
                scale: lerpDouble(1.0, 0.85, progress)!,
                child: Container(
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
                    size: avatarSize,
                  ),
                ),
              ),

              SizedBox(width: horizontalSpacing),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: 1 - progress,
                    child: AppText('welcome_back'.tr),
                  ),

                  SizedBox(height: AppSpacing.xs),

                  Transform.translate(
                    offset: Offset(0, -6 * progress),
                    child: AppText(
                      context.read<HomeCubit>().userModel?.name ?? 'user'.tr,
                      color: context.theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              InkWell(
                onTap: () => context.push(AppRoutes.timer),
                child: Icon(
                  Icons.timer,
                  color: context.theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
