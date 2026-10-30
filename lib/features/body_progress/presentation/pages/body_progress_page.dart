import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/models/user_model.dart';
import 'package:lift_log/features/body_progress/cubit/body_progress_cubit.dart';
import 'package:lift_log/features/body_progress/presentation/pages/body_progress_view.dart';
import 'package:lift_log/features/profile/cubit/profile_cubit.dart';

class BodyProgressPage extends StatelessWidget {
  const BodyProgressPage({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BodyProgressCubit(
        heightCm: user.height,
        userId: user.id,
        onWeightChanged: context.read<ProfileCubit>().updateWeightLocally,
      )..load(),
      child: const BodyProgressView(),
    );
  }
}
