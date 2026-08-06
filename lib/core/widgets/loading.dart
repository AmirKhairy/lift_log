import 'package:flutter/material.dart';
import 'package:lift_log/core/theme/app_colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
}
