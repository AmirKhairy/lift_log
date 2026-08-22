import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/utils/app_enums.dart';

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
    this.selectedTutorialVideo,
    this.tutorialVideos = const [],
    this.isTutorialVideosLoading = false,
    this.isSaving = false,
  });

  final XFile? selectedImage;
  final MuscleGroup? selectedMuscleGroup;
  final TutorialVideosModel? selectedTutorialVideo;
  final List<TutorialVideosModel> tutorialVideos;
  final bool isTutorialVideosLoading;
  final bool isSaving;

  AddMachineLoaded copyWith({
    XFile? selectedImage,
    MuscleGroup? selectedMuscleGroup,
    TutorialVideosModel? selectedTutorialVideo,
    List<TutorialVideosModel>? tutorialVideos,
    bool clearSelectedTutorialVideo = false,
    bool? isTutorialVideosLoading,
    bool? isSaving,
  }) {
    return AddMachineLoaded(
      selectedImage: selectedImage ?? this.selectedImage,
      selectedMuscleGroup: selectedMuscleGroup ?? this.selectedMuscleGroup,
      selectedTutorialVideo: clearSelectedTutorialVideo
          ? null
          : selectedTutorialVideo ?? this.selectedTutorialVideo,
      tutorialVideos: tutorialVideos ?? this.tutorialVideos,
      isTutorialVideosLoading:
          isTutorialVideosLoading ?? this.isTutorialVideosLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [
    selectedImage,
    selectedMuscleGroup,
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
