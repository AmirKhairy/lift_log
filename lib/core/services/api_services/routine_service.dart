import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/services/supabase_service.dart';

class RoutineService {
  RoutineService._();

  static final instance = RoutineService._();

  Future<List<RoutineModel>> getRoutines() async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) throw Exception('User is not logged in');

    final response = await SupabaseService.client
        .from('workout_routines')
        .select('''
          id,
          name,
          workout_routine_exercises(
            machine_id,
            notes,
            machines(id, user_id, name, image_url, muscle_group, target_muscle, tutorial_video_id, notes, created_at, updated_at),
            workout_routine_sets(set_number, weight, reps)
          )
        ''')
        .eq('user_id', userId)
        .order('created_at');

    return response
        .map((item) => RoutineModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> saveRoutine(
    String name,
    WorkoutDraft draft, {
    String? id,
  }) async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) throw Exception('User is not logged in');

    final routineId =
        id ??
        (await SupabaseService.client
                .from('workout_routines')
                .insert({'user_id': userId, 'name': name.trim()})
                .select('id')
                .single())['id']
            as String;

    if (id != null) {
      await SupabaseService.client
          .from('workout_routines')
          .update({'name': name.trim()})
          .eq('id', id)
          .eq('user_id', userId);
      await SupabaseService.client
          .from('workout_routine_exercises')
          .delete()
          .eq('routine_id', id);
    }

    for (final exercise in draft.machines) {
      final exerciseId =
          (await SupabaseService.client
                  .from('workout_routine_exercises')
                  .insert({
                    'routine_id': routineId,
                    'machine_id': exercise.machine.id,
                    'notes': exercise.notes.trim().isEmpty
                        ? null
                        : exercise.notes.trim(),
                  })
                  .select('id')
                  .single())['id']
              as String;
      await SupabaseService.client.from('workout_routine_sets').insert([
        for (final set in exercise.sets)
          {
            'routine_exercise_id': exerciseId,
            'set_number': set.setNumber,
            'weight': set.weight,
            'reps': set.reps,
          },
      ]);
    }
  }

  Future<void> deleteRoutine(String routineId) async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) throw Exception('User is not logged in');

    await SupabaseService.client
        .from('workout_routines')
        .delete()
        .eq('id', routineId)
        .eq('user_id', userId);
  }
}
