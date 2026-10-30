import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/services/supabase_service.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/utils/target_muscle.dart';

class TutorialVideosService {
  TutorialVideosService._();

  static final instance = TutorialVideosService._();

  final Map<String, List<TutorialVideosModel>> _cache = {};

  Map<String, List<TutorialVideosModel>> get cache => Map.unmodifiable(_cache);

  Future<List<TutorialVideosModel>> getByMuscleGroup(
    MuscleGroup muscleGroup, {
    TargetMuscle? targetMuscle,
    bool forceRefresh = false,
  }) async {
    final cacheKey =
        '${muscleGroup.toJson()}:${targetMuscle?.toJson() ?? 'all'}';
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey] ?? [];
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
          target_muscle,
          created_at
        ''')
          .eq('muscle_group', muscleGroup.toJson())
          .order('created_at', ascending: false);

      final filteredResponse = targetMuscle == null
          ? response
          : response.where(
              (item) => item['target_muscle'] == targetMuscle.toJson(),
            );
      final videos = filteredResponse
          .map((item) => TutorialVideosModel.fromJson(item))
          .toList();

      _cache[cacheKey] = videos;
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
          target_muscle,
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
