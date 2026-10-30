import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_card.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class BodyProgressMetricCard extends StatelessWidget {
  const BodyProgressMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.signed = false,
  });
  final String label;
  final double? value;
  final bool signed;
  @override
  Widget build(BuildContext context) {
    final display = value == null
        ? '-'.tr
        : '${signed && value! >= 0 ? '+' : ''}${value!.toStringAsFixed(1)} ${'weight_unit'.tr}';
    return AppCard(
      padding: AppPadding.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, color: context.appColors.subtitle, fontSize: 12.sp),
          SizedBox(height: AppSpacing.xs),
          value == null
              ? AppText('-', fontWeight: FontWeight.bold, fontSize: 18.sp)
              : AppText(display, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ],
      ),
    );
  }
}
