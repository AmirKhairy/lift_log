import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/services/api_services/machines_service.dart';
import 'package:lift_log/core/services/api_services/tutorial_videos_service.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/utils/target_muscle.dart';
import 'package:lift_log/features/add_machine/cubit/add_machine_state.dart';

class AddMachineCubit extends Cubit<AddMachineState> {
  AddMachineCubit({this.machineToEdit}) : super(const AddMachineLoaded());

  final MachineModel? machineToEdit;
  final MachinesService _machinesService = MachinesService.instance;
  final TutorialVideosService _tutorialVideosService =
      TutorialVideosService.instance;
  final ImagePicker _imagePicker = ImagePicker();

  bool get isEditing => machineToEdit != null;

  Future<void> hydrate() async {
    final muscleGroup = machineToEdit?.muscleGroup;
    if (muscleGroup == null) return;

    await selectMuscleGroup(muscleGroup);
    final targetMuscle = machineToEdit?.targetMuscle;
    if (targetMuscle != null) {
      await selectTargetMuscle(targetMuscle);
    }

    final tutorialVideoId = machineToEdit?.tutorialVideoId;
    if (tutorialVideoId == null || tutorialVideoId.isEmpty) return;

    final currentState = state;
    if (currentState is! AddMachineLoaded) return;

    final match = currentState.tutorialVideos
        .where((video) => video.id == tutorialVideoId)
        .firstOrNull;
    if (match == null) return;

    selectTutorialVideo(match);
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null || state is! AddMachineLoaded) return;

      final currentState = state as AddMachineLoaded;
      emit(_loaded(currentState, selectedImage: image));
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      emit(AddMachineError(e.toString()));
      emit(const AddMachineLoaded());
    }
  }

  Future<void> selectMuscleGroup(MuscleGroup muscleGroup) async {
    final currentState = state;
    if (currentState is! AddMachineLoaded) return;

    emit(
      _loaded(
        currentState,
        selectedMuscleGroup: muscleGroup,
        clearSelectedTargetMuscle: true,
        selectedTutorialVideo: null,
        clearSelectedTutorialVideo: true,
        tutorialVideos: const [],
        isTutorialVideosLoading: true,
      ),
    );

    try {
      final videos = await _tutorialVideosService.getByMuscleGroup(muscleGroup);

      final latestState = state;
      if (latestState is! AddMachineLoaded) return;

      emit(
        _loaded(
          latestState,
          tutorialVideos: videos,
          isTutorialVideosLoading: false,
        ),
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      final latestState = state;
      emit(AddMachineError(e.toString()));
      if (latestState is AddMachineLoaded) {
        emit(_loaded(latestState, isTutorialVideosLoading: false));
      }
    }
  }

  Future<void> selectTargetMuscle(TargetMuscle targetMuscle) async {
    final currentState = state;
    if (currentState is! AddMachineLoaded ||
        currentState.selectedMuscleGroup == null) {
      return;
    }

    emit(
      _loaded(
        currentState,
        selectedTargetMuscle: targetMuscle,
        selectedTutorialVideo: null,
        clearSelectedTutorialVideo: true,
        tutorialVideos: const [],
        isTutorialVideosLoading: true,
      ),
    );

    try {
      final videos = await _tutorialVideosService.getByMuscleGroup(
        currentState.selectedMuscleGroup!,
        targetMuscle: targetMuscle,
      );
      final latestState = state;
      if (latestState is AddMachineLoaded) {
        emit(
          _loaded(
            latestState,
            tutorialVideos: videos,
            isTutorialVideosLoading: false,
          ),
        );
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      emit(AddMachineError(e.toString()));
      final latestState = state;
      if (latestState is AddMachineLoaded) {
        emit(_loaded(latestState, isTutorialVideosLoading: false));
      }
    }
  }

  void selectTutorialVideo(TutorialVideosModel video) {
    final currentState = state;
    if (currentState is! AddMachineLoaded) return;

    emit(_loaded(currentState, selectedTutorialVideo: video));
  }

  Future<void> saveMachine({
    required String name,
    required String notes,
  }) async {
    final currentState = state;
    if (currentState is! AddMachineLoaded) return;

    final selectedImage = currentState.selectedImage;
    final muscleGroup = currentState.selectedMuscleGroup;
    if (muscleGroup == null) {
      emit(const AddMachineError('select_muscle_group'));
      emit(currentState);
      return;
    }
    final targetMuscle = currentState.selectedTargetMuscle;
    if (targetMuscle == null) {
      emit(const AddMachineError('select_target_muscle'));
      emit(currentState);
      return;
    }

    emit(_loaded(currentState, isSaving: true));

    try {
      final machine = isEditing
          ? await _machinesService.updateMachine(
              machine: machineToEdit!,
              name: name,
              notes: notes,
              muscleGroup: muscleGroup,
              targetMuscle: targetMuscle,
              tutorialVideoId: currentState.selectedTutorialVideo?.id,
              image: selectedImage,
            )
          : await _machinesService.addMachine(
              name: name,
              notes: notes,
              muscleGroup: muscleGroup,
              targetMuscle: targetMuscle,
              tutorialVideoId: currentState.selectedTutorialVideo?.id,
              image: selectedImage,
            );

      emit(AddMachineSuccess(machine));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(AddMachineError(e.toString()));
      emit(_loaded(currentState, isSaving: false));
    }
  }

  AddMachineLoaded _loaded(
    AddMachineLoaded current, {
    XFile? selectedImage,
    MuscleGroup? selectedMuscleGroup,
    TargetMuscle? selectedTargetMuscle,
    bool clearSelectedTargetMuscle = false,
    TutorialVideosModel? selectedTutorialVideo,
    List<TutorialVideosModel>? tutorialVideos,
    bool clearSelectedTutorialVideo = false,
    bool? isTutorialVideosLoading,
    bool? isSaving,
  }) {
    return AddMachineLoaded(
      selectedImage: selectedImage ?? current.selectedImage,
      selectedMuscleGroup: selectedMuscleGroup ?? current.selectedMuscleGroup,
      selectedTargetMuscle: clearSelectedTargetMuscle
          ? null
          : selectedTargetMuscle ?? current.selectedTargetMuscle,
      selectedTutorialVideo: clearSelectedTutorialVideo
          ? null
          : selectedTutorialVideo ?? current.selectedTutorialVideo,
      tutorialVideos: tutorialVideos ?? current.tutorialVideos,
      isTutorialVideosLoading:
          isTutorialVideosLoading ?? current.isTutorialVideosLoading,
      isSaving: isSaving ?? current.isSaving,
    );
  }
}
