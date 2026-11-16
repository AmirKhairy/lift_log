import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/services/api_services/app_settings_service.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/target_muscle.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class MachineImagePicker extends StatelessWidget {
  const MachineImagePicker({
    super.key,
    required this.image,
    required this.onTap,
    required this.onRemove,
    this.targetMuscle,
    this.selectedTargetMuscleImageUrl,
    this.existingImageUrl,
  });

  final XFile? image;
  final String? existingImageUrl;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final TargetMuscle? targetMuscle;
  final String? selectedTargetMuscleImageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 170.h,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.nm),
              color: context.theme.colorScheme.surface,
            ),
            child: _preview(context),
          ),
        ),
        if (image != null)
          PositionedDirectional(
            top: 8.h,
            end: 8.w,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: onRemove,
                tooltip: 'remove_image'.tr,
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _preview(BuildContext context) {
    if (image != null) {
      return Image.file(File(image!.path), fit: BoxFit.cover);
    }

    final existingUrl = existingImageUrl?.trim() ?? '';
    if (existingUrl.isNotEmpty) {
      return AppCachedNetworkImage(
        imageUrl: existingUrl,
        width: double.infinity,
        height: 170.h,
        fit: BoxFit.cover,
        errorWidget: const SizedBox.shrink(),
      );
    }

    final defaultUrl =
        selectedTargetMuscleImageUrl ??
        AppSettingsService.instance.targetMuscleImageUrl(targetMuscle);
    if (defaultUrl != null) {
      return AppCachedNetworkImage(
        imageUrl: defaultUrl,
        width: double.infinity,
        height: 170.h,
        fit: BoxFit.cover,
        errorWidget: const SizedBox.shrink(),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo_outlined,
          color: context.theme.colorScheme.primary,
          size: 34.sp,
        ),
        SizedBox(height: AppSpacing.sm),
        AppText(
          'upload_machine_photo_optional',
          color: context.appColors.subtitle,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
