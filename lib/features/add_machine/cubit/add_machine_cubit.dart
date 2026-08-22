import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/services/api_services/machines_service.dart';
import 'package:lift_log/core/services/api_services/tutorial_videos_service.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/features/add_machine/cubit/add_machine_state.dart';

class AddMachineCubit extends Cubit<AddMachineState> {
  AddMachineCubit() : super(const AddMachineLoaded());

  final MachinesService _machinesService = MachinesService.instance;
  final TutorialVideosService _tutorialVideosService =
      TutorialVideosService.instance;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null || state is! AddMachineLoaded) return;

      emit((state as AddMachineLoaded).copyWith(selectedImage: image));
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
      currentState.copyWith(
        selectedMuscleGroup: muscleGroup,
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
        latestState.copyWith(
          tutorialVideos: videos,
          isTutorialVideosLoading: false,
        ),
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      final latestState = state;
      emit(AddMachineError(e.toString()));
      if (latestState is AddMachineLoaded) {
        emit(latestState.copyWith(isTutorialVideosLoading: false));
      }
    }
  }

  void selectTutorialVideo(TutorialVideosModel video) {
    final currentState = state;
    if (currentState is! AddMachineLoaded) return;

    emit(currentState.copyWith(selectedTutorialVideo: video));
  }

  Future<void> saveMachine({
    required String name,
    required String notes,
  }) async {
    final currentState = state;
    if (currentState is! AddMachineLoaded) return;

    final selectedImage = currentState.selectedImage;
    if (selectedImage == null) {
      emit(const AddMachineError('select_machine_image'));
      emit(currentState);
      return;
    }

    final muscleGroup = currentState.selectedMuscleGroup;
    if (muscleGroup == null) {
      emit(const AddMachineError('select_muscle_group'));
      emit(currentState);
      return;
    }

    emit(currentState.copyWith(isSaving: true));

    try {
      final machine = await _machinesService.addMachine(
        name: name,
        notes: notes,
        muscleGroup: muscleGroup,
        tutorialVideoId: currentState.selectedTutorialVideo?.id,
        image: selectedImage,
      );

      emit(AddMachineSuccess(machine));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(AddMachineError(e.toString()));
      emit(currentState.copyWith(isSaving: false));
    }
  }
}
