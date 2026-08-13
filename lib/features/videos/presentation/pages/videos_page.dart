import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/videos_cubit.dart';
import '../../cubit/videos_state.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideosCubit, VideosState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Videos')),
          body: Center(
            child: switch (state) {
              VideosInitial() => const Text(
                'Videos is ready. Waiting for first load.',
              ),
              VideosLoading() => const CircularProgressIndicator(),
              VideosLoaded() => const Text('Videos loaded successfully'),
              VideosError(:final message) => Text('Videos error: $message'),
            },
          ),
        );
      },
    );
  }
}
