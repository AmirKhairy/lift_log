import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/body_progress_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'body_progress_section_card.dart';

class BodyProgressBmiCard extends StatelessWidget {
  const BodyProgressBmiCard({super.key, required this.stats});
  final BodyProgressStats stats;
  @override
  Widget build(BuildContext context) => BodyProgressSectionCard(
    title: 'bmi',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        stats.bmi == null
            ? AppText('-', fontSize: 28.sp, fontWeight: FontWeight.bold)
            : AppText(
                '${stats.bmi!.toStringAsFixed(1)} ${'bmi_unit'.tr}',
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
        SizedBox(height: AppSpacing.sm),
        AppText('bmi_limitation', color: context.appColors.subtitle),
      ],
    ),
  );
}
