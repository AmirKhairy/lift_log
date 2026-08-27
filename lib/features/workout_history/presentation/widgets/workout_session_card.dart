import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/features/workout_history/presentation/widgets/workout_log_tile.dart';

class WorkoutSessionCard extends StatelessWidget {
  const WorkoutSessionCard({super.key, required this.session});

  final WorkoutSessionModel session;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMMd().add_jm().format(session.performedAt);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: CircleAvatar(child: Icon(Icons.fitness_center, size: 20.sp)),
        title: Text(date),
        subtitle: Text('${session.logs.length} ${'exercises'.tr}'),
        childrenPadding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        children: [
          if (session.notes?.isNotEmpty == true)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(session.notes!),
              ),
            ),
          for (final log in session.logs) WorkoutLogTile(log: log),
        ],
      ),
    );
  }
}
