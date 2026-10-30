import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/helpers/validators.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/router/app_router.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/target_muscle.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_labeled_text_field.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_staggered_animation.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';
import 'package:lift_log/features/add_machine/cubit/add_machine_cubit.dart';
import 'package:lift_log/features/add_machine/cubit/add_machine_state.dart'
    hide AddMachineLoading;
import 'package:lift_log/features/add_machine/presentation/widgets/add_machine_loading.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/image_source_tile.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/machine_image_picker.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/muscle_group_selector.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/performance_tip_card.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/target_muscle_selector.dart';
import 'package:lift_log/features/add_machine/presentation/widgets/tutorial_video_selector.dart';

class AddMachineView extends StatefulWidget {
  const AddMachineView({super.key, this.machineToEdit});

  final MachineModel? machineToEdit;

  @override
  AddMachineViewState createState() => AddMachineViewState();
}

class AddMachineViewState extends State<AddMachineView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.machineToEdit?.name ?? '';
    _notesController.text = widget.machineToEdit?.notes ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AddMachineCubit>().saveMachine(
      name: _nameController.text,
      notes: _notesController.text,
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageSourceTile(
                icon: Icons.photo_camera_outlined,
                title: 'camera',
                onTap: () {
                  sheetContext.pop();
                  context.read<AddMachineCubit>().pickImage(ImageSource.camera);
                },
              ),
              SizedBox(height: AppSpacing.sm),
              ImageSourceTile(
                icon: Icons.photo_library_outlined,
                title: 'gallery',
                onTap: () {
                  sheetContext.pop();
                  context.read<AddMachineCubit>().pickImage(
                    ImageSource.gallery,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _playTutorialVideo(TutorialVideosModel video) {
    if (video.videoUrl?.trim().isEmpty ?? true) {
      AppSnackbar.error(message: 'video_link_not_available', context: context);
      return;
    }

    context.push(AppRoutes.tutorialVideoPlayer, extra: video);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMachineCubit, AddMachineState>(
      listener: (context, state) {
        if (state is AddMachineError) {
          AppSnackbar.error(message: state.message, context: context);
        }
        if (state is AddMachineSuccess) context.pop(state.machine);
      },
      builder: (context, state) => AppScaffold(
        title: widget.machineToEdit == null
            ? 'add_new_machine'
            : 'edit_machine',
        centerTitle: false,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        body: state is AddMachineLoaded
            ? Form(
                key: _formKey,
                child: ListView(
                  children: [
                    AppStaggeredAnimation(
                      index: 0,
                      child: MachineImagePicker(
                        image: state.selectedImage,
                        existingImageUrl: widget.machineToEdit?.imageUrl,
                        onTap: _showImageSourceSheet,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    AppStaggeredAnimation(
                      index: 1,
                      child: LabeledTextField(
                        label: 'machine_name',
                        child: AppTextField(
                          controller: _nameController,
                          hint: 'machine_name_hint',
                          validator: Validators.name,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppStaggeredAnimation(
                      index: 2,
                      child: LabeledTextField(
                        label: 'description',
                        child: AppTextField(
                          controller: _notesController,
                          hint: 'machine_description_hint',
                          maxLines: 4,
                          textInputAction: TextInputAction.newline,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppStaggeredAnimation(
                      index: 3,
                      child: LabeledTextField(
                        label: 'primary_muscle_group',
                        child: MuscleGroupSelector(
                          selectedMuscleGroup: state.selectedMuscleGroup,
                          onSelected: context
                              .read<AddMachineCubit>()
                              .selectMuscleGroup,
                        ),
                      ),
                    ),
                    if (state.selectedMuscleGroup != null) ...[
                      SizedBox(height: AppSpacing.md),
                      LabeledTextField(
                        label: 'target_muscle',
                        child: TargetMuscleSelector(
                          options: targetMusclesFor(state.selectedMuscleGroup!),
                          selected: state.selectedTargetMuscle,
                          onSelected: context
                              .read<AddMachineCubit>()
                              .selectTargetMuscle,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      if (state.selectedTargetMuscle != null)
                        AppStaggeredAnimation(
                          index: 4,
                          child: LabeledTextField(
                            label: 'tutorial_videos_selection_label',
                            child: TutorialVideoSelector(
                              videos: state.tutorialVideos,
                              selectedVideo: state.selectedTutorialVideo,
                              isLoading: state.isTutorialVideosLoading,
                              onSelected: context
                                  .read<AddMachineCubit>()
                                  .selectTutorialVideo,
                              onPlay: _playTutorialVideo,
                            ),
                          ),
                        ),
                    ],
                    SizedBox(height: AppSpacing.md),
                    const AppStaggeredAnimation(
                      index: 5,
                      child: PerformanceTipCard(),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    AppStaggeredAnimation(
                      index: 6,
                      child: AppButton(
                        title: 'save_machine',
                        loading: state.isSaving,
                        icon: Icon(Icons.save_outlined, size: 24.sp),
                        onPressed: _save,
                      ),
                    ),
                  ],
                ),
              )
            : const AddMachineLoading(),
      ),
    );
  }
}
