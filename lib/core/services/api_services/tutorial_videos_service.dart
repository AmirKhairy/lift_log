import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/services/supabase_service.dart';
import 'package:lift_log/core/utils/app_enums.dart';

class TutorialVideosService {
  TutorialVideosService._();

  static final instance = TutorialVideosService._();

  final Map<MuscleGroup, List<TutorialVideosModel>> _cache = {};

  Map<MuscleGroup, List<TutorialVideosModel>> get cache =>
      Map.unmodifiable(_cache);

  Future<List<TutorialVideosModel>> getByMuscleGroup(
    MuscleGroup muscleGroup, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.containsKey(muscleGroup)) {
      return _cache[muscleGroup] ?? [];
    }

    try {
      final response = await SupabaseService.client
          .from('tutorial_videos')
          .select('''
          id,
          title,
          description,
          video_url,
          thumbnail_url,
          muscle_group,
          created_at
        ''')
          .eq('muscle_group', muscleGroup.toJson())
          .order('created_at', ascending: false);

      final videos = response
          .map((item) => TutorialVideosModel.fromJson(item))
          .toList();

      _cache[muscleGroup] = videos;
      return videos;
    } catch (e) {
      throw Exception('Failed to fetch tutorial videos: $e');
    }
  }

  Future<TutorialVideosModel?> getById(String id) async {
    try {
      final response = await SupabaseService.client
          .from('tutorial_videos')
          .select('''
          id,
          title,
          description,
          video_url,
          thumbnail_url,
          muscle_group,
          created_at
        ''')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return TutorialVideosModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch tutorial video: $e');
    }
  }
}
