import 'package:lift_log/core/services/supabase_service.dart';
import 'package:lift_log/core/utils/target_muscle.dart';

class AppSettingsService {
  AppSettingsService._();

  static final instance = AppSettingsService._();

  Map<String, List<String>> _targetMuscleImageUrls = const {};

  List<String> targetMuscleImageUrls(TargetMuscle? targetMuscle) {
    if (targetMuscle == null) return const [];
    return _targetMuscleImageUrls[targetMuscle.toJson()] ?? const [];
  }

  String? targetMuscleImageUrl(TargetMuscle? targetMuscle) {
    final urls = targetMuscleImageUrls(targetMuscle);
    return urls.isEmpty ? null : urls.first;
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
          if (entry.key is String)
            entry.key as String: _parseUrls(entry.value),
      };
    } catch (_) {}
  }

  List<String> _parseUrls(Object? value) {
    final values = value is List ? value : [value];
    return [
      for (final item in values)
        if (item is String && item.trim().isNotEmpty) item.trim(),
    ];
  }
}
