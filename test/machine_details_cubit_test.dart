import 'package:flutter_test/flutter_test.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/features/machine_details/cubit/machine_details_cubit.dart';
import 'package:lift_log/features/machine_details/cubit/machine_details_state.dart';

void main() {
  final machine = MachineModel(
    id: 'machine-1',
    name: 'Leg Press',
    muscleGroup: MuscleGroup.legs,
    tutorialVideoId: 'video-1',
    imageUrl: 'https://example.com/machine.jpg',
  );

  final tutorial = TutorialVideosModel(
    id: 'video-1',
    title: 'Leg Press Form',
    videoUrl: 'https://example.com/video.mp4',
  );

  final historyItem = MachineWorkoutHistoryItem(
    performedAt: DateTime(2026, 8, 1),
    logNotes: 'Felt strong',
    sets: const [WorkoutSetModel(setNumber: 1, weight: 100, reps: 10)],
  );

  MachineDetailsCubit buildCubit({
    Future<TutorialVideosModel?> Function(String id)? getTutorialById,
    Future<List<MachineWorkoutHistoryItem>> Function(String machineId)?
    getLogsForMachine,
    Future<void> Function(String machineId, {String? imageUrl})?
    deleteMachineFn,
  }) {
    return MachineDetailsCubit(
      machine: machine,
      getTutorialById: getTutorialById ?? (_) async => tutorial,
      getLogsForMachine: getLogsForMachine ?? (_) async => [historyItem],
      deleteMachineFn: deleteMachineFn ?? (_, {imageUrl}) async {},
    );
  }

  test('emits loaded with tutorial and history', () async {
    final cubit = buildCubit();

    await cubit.load();

    final state = cubit.state as MachineDetailsLoaded;
    expect(state.machine.id, 'machine-1');
    expect(state.tutorial?.id, 'video-1');
    expect(state.history, hasLength(1));
    expect(state.tutorialError, isNull);
    expect(state.historyError, isNull);
  });

  test('keeps the machine when tutorial or history fetch fails', () async {
    final cubit = buildCubit(
      getTutorialById: (_) async => throw Exception('tutorial down'),
      getLogsForMachine: (_) async => throw Exception('history down'),
    );

    await cubit.load();

    final state = cubit.state as MachineDetailsLoaded;
    expect(state.machine.id, 'machine-1');
    expect(state.tutorial, isNull);
    expect(state.history, isEmpty);
    expect(state.tutorialError, contains('tutorial down'));
    expect(state.historyError, contains('history down'));
  });

  test('replaceMachine reloads details and marks a mutation', () async {
    final cubit = buildCubit();
    await cubit.load();

    final updated = MachineModel(
      id: 'machine-1',
      name: 'Seated Leg Press',
      muscleGroup: MuscleGroup.legs,
    );

    await cubit.replaceMachine(updated);

    final state = cubit.state as MachineDetailsLoaded;
    expect(state.machine.name, 'Seated Leg Press');
    expect(cubit.didMutate, isTrue);
  });

  test('editMachine opens the editor and replaces the machine', () async {
    final cubit = buildCubit();
    await cubit.load();

    var editorMachineId = '';
    final updated = machine.copyWith(name: 'Seated Leg Press');
    final didEdit = await cubit.editMachine(
      openEditor: (currentMachine) async {
        editorMachineId = currentMachine.id!;
        return updated;
      },
    );

    expect(didEdit, isTrue);
    expect(editorMachineId, 'machine-1');
    expect(
      (cubit.state as MachineDetailsLoaded).machine.name,
      'Seated Leg Press',
    );
  });

  test('openTutorial only opens tutorials with a video link', () {
    final cubit = buildCubit();
    TutorialVideosModel? openedTutorial;

    expect(
      cubit.openTutorial(
        tutorial: tutorial,
        openPlayer: (value) => openedTutorial = value,
      ),
      isTrue,
    );
    expect(openedTutorial, tutorial);
    expect(
      cubit.openTutorial(tutorial: null, openPlayer: (_) {}),
      isFalse,
    );
  });

  test('deleteMachine emits deleted after a successful load', () async {
    var deletedId = '';
    final cubit = buildCubit(
      deleteMachineFn: (machineId, {imageUrl}) async {
        deletedId = machineId;
      },
    );

    await cubit.load();
    await cubit.deleteMachine();

    expect(deletedId, 'machine-1');
    expect(cubit.state, isA<MachineDetailsDeleted>());
    expect(cubit.didMutate, isTrue);
  });

  test('emits error then restores loaded when delete fails', () async {
    final cubit = buildCubit(
      deleteMachineFn: (_, {imageUrl}) async {
        throw Exception('delete failed');
      },
    );
    final states = <MachineDetailsState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.load();
    await cubit.deleteMachine();
    await subscription.cancel();

    final state = cubit.state as MachineDetailsLoaded;
    expect(states, contains(isA<MachineDetailsDeleting>()));
    expect(state, isA<MachineDetailsLoaded>());
    expect(cubit.didMutate, isFalse);
  });
}
