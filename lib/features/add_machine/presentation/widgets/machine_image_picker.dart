import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_assets.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class MachineImagePicker extends StatelessWidget {
  const MachineImagePicker({
    super.key,
    required this.image,
    required this.onTap,
    this.existingImageUrl,
  });

  final XFile? image;
  final String? existingImageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        errorWidget: Image.asset(AppAssets.logo, fit: BoxFit.contain),
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
