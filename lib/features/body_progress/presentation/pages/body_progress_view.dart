import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/utils/app_padding.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/features/body_progress/cubit/body_progress_cubit.dart';
import 'package:lift_log/features/body_progress/cubit/body_progress_state.dart';
import 'package:lift_log/features/body_progress/presentation/pages/body_progress_loaded_view.dart';
import 'package:lift_log/features/body_progress/presentation/widgets/body_progress_loading_shimmer.dart';

class BodyProgressView extends StatelessWidget {
  const BodyProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: AppText('body_progress')),
      body: BlocBuilder<BodyProgressCubit, BodyProgressState>(
        builder: (context, state) {
          if (state is BodyProgressInitial || state is BodyProgressLoading) {
            return const BodyProgressLoadingShimmer();
          }
          if (state is BodyProgressError) {
            return Center(
              child: Padding(
                padding: AppPadding.horizontal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      '${'body_progress_error'.tr}: ${state.message}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      title: 'retry',
                      width: 150,
                      onPressed: context.read<BodyProgressCubit>().load,
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is BodyProgressLoaded) {
            return BodyProgressLoadedView(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
