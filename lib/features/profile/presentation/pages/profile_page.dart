import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Center(
            child: switch (state) {
              ProfileInitial() => const Text(
                'Profile is ready. Waiting for first load.',
              ),
              ProfileLoading() => const CircularProgressIndicator(),
              ProfileLoaded() => const Text('Profile loaded successfully'),
              ProfileError(:final message) => Text('Profile error: $message'),
            },
          ),
        );
      },
    );
  }
}
