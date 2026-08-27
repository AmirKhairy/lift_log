import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/services/supabase_service.dart';

class WorkoutService {
  WorkoutService._();

  static final instance = WorkoutService._();

  Future<void> saveWorkout(WorkoutDraft draft) async {
    final userId = SupabaseService.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    await SupabaseService.client.rpc(
      'save_workout',
      params: {
        'p_user_id': userId,
        'p_performed_at': draft.performedAt.toUtc().toIso8601String(),
        'p_notes': draft.notes.trim().isEmpty ? null : draft.notes.trim(),
        'p_machines': [
          for (final machineLog in draft.machines)
            {
              'machine_id': machineLog.machine.id,
              'notes': machineLog.notes.trim().isEmpty
                  ? null
                  : machineLog.notes.trim(),
              'sets': [
                for (final set in machineLog.sets)
                  {
                    'set_number': set.setNumber,
                    'weight': set.weight,
                    'reps': set.reps,
                  },
              ],
            },
        ],
      },
    );
  }

  Future<List<DateTime>> getWorkoutDates({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final userId = SupabaseService.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final response = await SupabaseService.client
        .from('workout_sessions')
        .select('performed_at')
        .eq('user_id', userId)
        .gte('performed_at', startDate.toUtc().toIso8601String())
        .lt('performed_at', endDate.toUtc().toIso8601String())
        .order('performed_at', ascending: false);

    return response
        .map((item) => DateTime.parse(item['performed_at'] as String).toLocal())
        .toList();
  }

  Future<List<WorkoutSessionModel>> getWorkoutSessions() async {
    final userId = SupabaseService.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final response = await SupabaseService.client
        .from('workout_sessions')
        .select('''
          id,
          performed_at,
          notes,
          workout_logs(
            id,
            notes,
            machines(
              id,
              user_id,
              name,
              image_url,
              muscle_group,
              tutorial_video_id,
              notes,
              created_at,
              updated_at
            ),
            workout_sets(
              set_number,
              weight,
              reps
            )
          )
        ''')
        .eq('user_id', userId)
        .order('performed_at', ascending: false);

    return response
        .map(
          (item) =>
              WorkoutSessionModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  Future<int> getMachineCount() async {
    final userId = SupabaseService.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final response = await SupabaseService.client
        .from('machines')
        .select('id, user_id')
        .eq('user_id', userId);

    return response.length;
  }
}
