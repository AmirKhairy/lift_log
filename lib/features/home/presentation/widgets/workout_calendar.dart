import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/utils/app_radius.dart';
import 'package:lift_log/features/home/presentation/widgets/workout_day.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutCalendar extends StatefulWidget {
  const WorkoutCalendar({super.key, required this.workoutDates});

  final List<DateTime> workoutDates;

  @override
  State<WorkoutCalendar> createState() => _WorkoutCalendarState();
}

class _WorkoutCalendarState extends State<WorkoutCalendar> {
  late DateTime _focusedDay;

  bool _isMovingForward = true;

  @override
  void initState() {
    super.initState();

    _focusedDay = DateTime.now();
  }

  bool _isWorkoutDay(DateTime day) {
    return widget.workoutDates.any(
      (workoutDate) => isSameDay(workoutDate, day),
    );
  }

  int _getWorkoutAnimationIndex(DateTime day) {
    return widget.workoutDates.indexWhere(
      (workoutDate) => isSameDay(workoutDate, day),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar(
      key: ValueKey('${_focusedDay.year}-${_focusedDay.month}'),

      firstDay: DateTime(2020),
      lastDay: DateTime(2030),
      focusedDay: _focusedDay,

      calendarFormat: CalendarFormat.month,

      availableCalendarFormats: const {CalendarFormat.month: 'Month'},

      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: context.theme.colorScheme.onSurface,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: context.theme.colorScheme.onSurface,
        ),
        titleTextStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      daysOfWeekHeight: 30.h,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: context.theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        weekendStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: context.theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),

      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,

        defaultTextStyle: TextStyle(
          fontSize: 14.sp,
          color: context.theme.colorScheme.onSurface,
        ),

        weekendTextStyle: TextStyle(
          fontSize: 14.sp,
          color: context.theme.colorScheme.onSurface,
        ),

        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: context.theme.colorScheme.primary,
            width: 1.5.w,
          ),
        ),

        todayTextStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: context.theme.colorScheme.primary,
        ),
      ),

      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          if (!_isWorkoutDay(day)) {
            return null;
          }

          return WorkoutDay(
            day: day,
            color: context.theme.colorScheme.primary,
            animationIndex: _getWorkoutAnimationIndex(day),
          );
        },

        todayBuilder: (context, day, focusedDay) {
          if (!_isWorkoutDay(day)) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.theme.colorScheme.primary,
                  width: 1.5.w,
                ),
              ),
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: context.theme.colorScheme.primary,
                ),
              ),
            );
          }

          return WorkoutDay(
            day: day,
            color: context.theme.colorScheme.primary,
            isToday: true,
            animationIndex: _getWorkoutAnimationIndex(day),
          );
        },
      ),

      onPageChanged: (focusedDay) {
        setState(() {
          _isMovingForward = focusedDay.isAfter(_focusedDay);
          _focusedDay = focusedDay;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPadding.horizontal,
      padding: EdgeInsets.all(AppSpacing.nm),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'workout_calendar'.tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: context.theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final beginOffset = _isMovingForward
                  ? const Offset(0.15, 0)
                  : const Offset(-0.15, 0);

              final slideAnimation = Tween<Offset>(
                begin: beginOffset,
                end: Offset.zero,
              ).animate(animation);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slideAnimation, child: child),
              );
            },
            child: _buildCalendar(context),
          ),
        ],
      ),
    );
  }
}
