import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class MachineImagePicker extends StatelessWidget {
  const MachineImagePicker({
    super.key,
    required this.image,
    required this.onTap,
  });

  final XFile? image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: context.appColors.border,
          radius: AppSpacing.nm,
        ),
        child: Container(
          height: 170.h,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.nm),
            color: context.theme.colorScheme.surface,
          ),
          child: image == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      color: context.theme.colorScheme.primary,
                      size: 34.sp,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    AppText(
                      'upload_machine_photo',
                      color: context.appColors.subtitle,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                )
              : Image.file(File(image!.path), fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dashWidth = 6.0;
      const dashSpace = 5.0;

      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
