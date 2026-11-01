import 'package:lift_log/core/services/supabase_service.dart';
import 'package:lift_log/core/utils/target_muscle.dart';

class AppSettingsService {
  AppSettingsService._();

  static final instance = AppSettingsService._();

  Map<String, String> _targetMuscleImageUrls = const {};

  String? targetMuscleImageUrl(TargetMuscle? targetMuscle) {
    if (targetMuscle == null) return null;

    final url = _targetMuscleImageUrls[targetMuscle.toJson()]?.trim();
    return url == null || url.isEmpty ? null : url;
  }

  Future<void> load() async {
    try {
      final response = await SupabaseService.client
          .from('app_settings')
          .select('target_muscle_image_urls')
          .eq('id', 1)
          .maybeSingle()
          .timeout(const Duration(seconds: 5));

      final rawUrls = response?['target_muscle_image_urls'];
      if (rawUrls is! Map) return;

      _targetMuscleImageUrls = {
        for (final entry in rawUrls.entries)
          if (entry.key is String && entry.value is String)
            entry.key as String: entry.value as String,
      };
    } catch (_) {}
  }
}
