import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';

class WorkoutDay extends StatefulWidget {
  const WorkoutDay({
    super.key,
    required this.day,
    required this.color,
    this.isToday = false,
    this.animationIndex = 0,
  });

  final DateTime day;
  final Color color;
  final bool isToday;
  final int animationIndex;

  @override
  State<WorkoutDay> createState() => _WorkoutDayState();
}

class _WorkoutDayState extends State<WorkoutDay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    final delay = Duration(milliseconds: widget.animationIndex * 70);

    await Future.delayed(delay);

    if (!mounted) return;

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        margin: EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          border: widget.isToday
              ? Border.all(
                  color: context.theme.colorScheme.onPrimary,
                  width: 2.w,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '${widget.day.day}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: context.theme.colorScheme.onPrimary,
          ),
        ),
      ),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        );
      },
    );
  }
}
