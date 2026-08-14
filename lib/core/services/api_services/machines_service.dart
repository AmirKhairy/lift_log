import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/services/supabase_service.dart';

class MachinesService {
  MachinesService._();

  static final instance = MachinesService._();

  List<MachineModel>? machines;

  Future<void> getMachines() async {
    try {
      final userId = SupabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User is not logged in');
      }

      final response = await SupabaseService.client
          .from('machines')
          .select('''
          id,
          user_id,
          name,
          image_url,
          muscle_group,
          tutorial_video_id,
          notes,
          created_at,
          updated_at
        ''')
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      machines = response.map((item) => MachineModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch machines: $e');
    }
  }
}
