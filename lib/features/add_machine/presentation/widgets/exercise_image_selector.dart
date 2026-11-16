import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';

class ExerciseImageSelector extends StatelessWidget {
  const ExerciseImageSelector({
    super.key,
    required this.imageUrls,
    required this.selectedUrl,
    required this.onSelected,
  });

  final List<String> imageUrls;
  final String? selectedUrl;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 104.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final url = imageUrls[index];
          final selected = url == selectedUrl;
          return GestureDetector(
            onTap: () => onSelected(url),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 132.w,
              padding: EdgeInsets.all(selected ? 3.w : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.nm),
                border: Border.all(
                  color: selected
                      ? context.theme.colorScheme.primary
                      : context.appColors.border,
                  width: selected ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                child: AppCachedNetworkImage(
                  imageUrl: url,
                  width: 132.w,
                  height: 104.h,
                  fit: BoxFit.cover,
                  errorWidget: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
