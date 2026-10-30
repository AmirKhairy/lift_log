import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class BodyProgressPeriodSelector extends StatelessWidget {
  const BodyProgressPeriodSelector({
    super.key,
    required this.selectedDays,
    required this.onSelected,
  });
  final int selectedDays;
  final ValueChanged<int> onSelected;
  static const periods = [
    (0, 'all_time'),
    (7, 'last_week'),
    (30, 'last_month'),
    (365, 'last_year'),
  ];
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (final period in periods)
          Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: ChoiceChip(
              label: AppText(period.$2),
              selected: selectedDays == period.$1,
              onSelected: (_) => onSelected(period.$1),
            ),
          ),
      ],
    ),
  );
}
