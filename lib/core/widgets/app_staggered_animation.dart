import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppStaggeredAnimation extends StatelessWidget {
  const AppStaggeredAnimation({
    super.key,
    required this.child,
    required this.index,
  });

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: Duration(milliseconds: index * 80))
        .fadeIn(duration: const Duration(milliseconds: 350))
        .moveY(begin: 20, end: 0, duration: const Duration(milliseconds: 350));
  }
}
