import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';

class HomeShimmerBox extends StatelessWidget {
  const HomeShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
  });

  final double width;
  final double height;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onSurface,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(6.r)
            : null,
      ),
    );
  }
}
