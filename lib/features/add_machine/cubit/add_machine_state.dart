import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/utils/target_muscle.dart';

sealed class AddMachineState extends Equatable {
  const AddMachineState();

  @override
  List<Object?> get props => [];
}

final class AddMachineInitial extends AddMachineState {
  const AddMachineInitial();
}

final class AddMachineLoading extends AddMachineState {
  const AddMachineLoading();
}

final class AddMachineLoaded extends AddMachineState {
  const AddMachineLoaded({
    this.selectedImage,
    this.selectedMuscleGroup,
    this.selectedTargetMuscle,
    this.selectedTutorialVideo,
    this.tutorialVideos = const [],
    this.isTutorialVideosLoading = false,
    this.isSaving = false,
  });

  final XFile? selectedImage;
  final MuscleGroup? selectedMuscleGroup;
  final TargetMuscle? selectedTargetMuscle;
  final TutorialVideosModel? selectedTutorialVideo;
  final List<TutorialVideosModel> tutorialVideos;
  final bool isTutorialVideosLoading;
  final bool isSaving;

  @override
  List<Object?> get props => [
    selectedImage,
    selectedMuscleGroup,
    selectedTargetMuscle,
    selectedTutorialVideo,
    tutorialVideos,
    isTutorialVideosLoading,
    isSaving,
  ];
}

final class AddMachineSuccess extends AddMachineState {
  const AddMachineSuccess(this.machine);

  final MachineModel machine;

  @override
  List<Object?> get props => [machine];
}

final class AddMachineError extends AddMachineState {
  const AddMachineError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
