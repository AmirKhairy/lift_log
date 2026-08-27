import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class WorkoutHistoryEmptyView extends StatelessWidget {
  const WorkoutHistoryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText('no_workouts'.tr, textAlign: TextAlign.center),
    );
  }
}
