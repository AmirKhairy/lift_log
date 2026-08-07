import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/context_extension.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.theme.colorScheme.primary,
      ),
    );
  }
}
