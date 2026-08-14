import 'package:lift_log/core/services/supabase_service.dart';

class WorkoutService {
  WorkoutService._();

  static final instance = WorkoutService._();

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
        .order('performed_at');

    return response
        .map((item) => DateTime.parse(item['performed_at'] as String).toLocal())
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
