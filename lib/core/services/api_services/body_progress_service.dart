import 'package:lift_log/core/models/body_progress_models.dart';
import 'package:lift_log/core/services/supabase_service.dart';

class BodyProgressService {
  BodyProgressService._();

  static final instance = BodyProgressService._();

  String get _userId {
    final id = SupabaseService.currentUser?.id;
    if (id == null) throw Exception('User is not logged in');
    return id;
  }

  Future<List<BodyWeightEntry>> getWeightEntries() async {
    final response = await SupabaseService.client
        .from('body_weight_entries')
        .select()
        .eq('user_id', _userId)
        .order('measured_at');
    return response
        .map(
          (item) => BodyWeightEntry.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  Future<BodyWeightEntry> addWeight({
    required double weight,
    required DateTime measuredAt,
  }) async {
    final response = await SupabaseService.client
        .from('body_weight_entries')
        .insert({
          'user_id': _userId,
          'weight': weight,
          'measured_at': measuredAt.toUtc().toIso8601String(),
        })
        .select()
        .single();
    return BodyWeightEntry.fromJson(Map<String, dynamic>.from(response));
  }

  Future<BodyWeightEntry> updateWeight({
    required String id,
    required double weight,
    required DateTime measuredAt,
  }) async {
    final response = await SupabaseService.client
        .from('body_weight_entries')
        .update({
          'weight': weight,
          'measured_at': measuredAt.toUtc().toIso8601String(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', id)
        .eq('user_id', _userId)
        .select()
        .single();
    return BodyWeightEntry.fromJson(Map<String, dynamic>.from(response));
  }

  Future<void> deleteWeight(String id) async {
    await SupabaseService.client
        .from('body_weight_entries')
        .delete()
        .eq('id', id)
        .eq('user_id', _userId);
  }

  Future<List<WeightGoal>> getGoals() async {
    final response = await SupabaseService.client
        .from('weight_goals')
        .select()
        .eq('user_id', _userId)
        .order('started_at', ascending: false);
    return response
        .map((item) => WeightGoal.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<WeightGoal> setGoal(double targetWeight) async {
    final userId = _userId;
    await SupabaseService.client
        .from('weight_goals')
        .update({'ended_at': DateTime.now().toUtc().toIso8601String()})
        .eq('user_id', userId)
        .isFilter('ended_at', null);
    final response = await SupabaseService.client
        .from('weight_goals')
        .insert({'user_id': userId, 'target_weight': targetWeight})
        .select()
        .single();
    return WeightGoal.fromJson(Map<String, dynamic>.from(response));
  }

  Future<void> removeGoal(String id) async {
    await SupabaseService.client
        .from('weight_goals')
        .update({'ended_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', id)
        .eq('user_id', _userId);
  }
}
