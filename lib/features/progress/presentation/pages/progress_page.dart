import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/progress_cubit.dart';
import '../../cubit/progress_state.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Progress')),
          body: Center(
            child: switch (state) {
              ProgressInitial() => const Text(
                'Progress is ready. Waiting for first load.',
              ),
              ProgressLoading() => const CircularProgressIndicator(),
              ProgressLoaded() => const Text('Progress loaded successfully'),
              ProgressError(:final message) => Text('Progress error: $message'),
            },
          ),
        );
      },
    );
  }
}
