import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/utils/logic_utilities.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class MachineItemWidget extends StatefulWidget {
  const MachineItemWidget({
    super.key,
    required this.machine,
    this.index = 0,
    this.onDelete,
    this.onChanged,
  });

  final MachineModel? machine;
  final int index;
  final VoidCallback? onDelete;
  final VoidCallback? onChanged;
  @override
  State<MachineItemWidget> createState() => _MachineItemWidgetState();
}

class _MachineItemWidgetState extends State<MachineItemWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final delay = (widget.index * 80).clamp(0, 400);

    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        _controller.forward();
      }
    });

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child:
              InkWell(
                    onTap: () async {
                      final result = await context.push(
                        AppRoutes.machineDetails,
                        extra: widget.machine,
                      );
                      if (!mounted) return;
                      if (result == true || result is MachineModel) {
                        widget.onChanged?.call();
                      }
                    },
                    child: Container(
                      padding: AppPadding.xs,
                      margin: AppPadding.xs,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                        color: context.theme.colorScheme.surface,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText(
                                      '${'machine_name'.tr}:',
                                      color:
                                          context.theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.sp,
                                    ),
                                    SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: AppText(
                                        widget.machine?.name ?? '',
                                        color:
                                            context.theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSpacing.sm),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText(
                                      '${'muscle_group'.tr}:',
                                      color:
                                          context.theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.sp,
                                    ),
                                    SizedBox(width: AppSpacing.sm),
                                    AppText(
                                      widget
                                              .machine
                                              ?.muscleGroup
                                              ?.displayName ??
                                          '',
                                      color: context.theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),

                          Stack(
                            alignment: AlignmentDirectional.topStart,
                            children: [
                              AppCachedNetworkImage(
                                imageUrl: widget.machine?.imageUrl ?? '',
                                width: 120.w,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.sm,
                                ),
                              ),
                              Positioned(
                                top: -10.h,
                                right:
                                    LogicUtilities.instance.isArabicLanguage()
                                    ? null
                                    : -10.w,

                                left: LogicUtilities.instance.isArabicLanguage()
                                    ? -10.w
                                    : null,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          _showDeleteConfirmationDialog(
                                            context,
                                            () {
                                              Navigator.of(context).pop();
                                              widget.onDelete?.call();
                                            },
                                          ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete_forever_outlined,
                                    size: 24.sp,
                                  ),
                                  color: context.theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    duration: 500.ms,
                    delay: Duration(milliseconds: widget.index * 80),
                  )
                  .slideY(
                    begin: 0.15,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .scale(
                    begin: const Offset(0.96, 0.96),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.easeOutCubic,
                  ),
        ),
      ),
    );
  }

  AlertDialog _showDeleteConfirmationDialog(
    BuildContext context,
    VoidCallback onDelete,
  ) {
    return AlertDialog(
      title: AppText(
        'delete_machine'.tr,
        color: context.theme.colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
      ),
      content: AppText(
        'delete_machine_confirmation'.tr,
        color: context.theme.colorScheme.onSurface,
        fontWeight: FontWeight.normal,
        fontSize: 16.sp,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: AppText(
            'cancel'.tr,
            color: context.theme.colorScheme.primary,
            fontWeight: FontWeight.normal,
            fontSize: 16.sp,
          ),
        ),
        TextButton(
          onPressed: onDelete,
          child: AppText(
            'delete'.tr,
            color: context.theme.colorScheme.error,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
