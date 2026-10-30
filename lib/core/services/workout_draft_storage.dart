import 'dart:convert';

import 'package:lift_log/core/constants/app_keys.dart';
import 'package:lift_log/core/models/workout_models.dart';
import 'package:lift_log/core/services/storage_service.dart';

class WorkoutDraftStorage {
  WorkoutDraftStorage._();

  static final instance = WorkoutDraftStorage._();

  String get _key {
    final userId = StorageService.getString(AppKeys.userId);
    return '${AppKeys.workoutDraft}_${userId ?? 'anonymous'}';
  }

  Future<WorkoutDraft?> load() async {
    if (!StorageService.isInitialized) return null;
    try {
      final raw = StorageService.getString(_key);
      if (raw == null || raw.isEmpty) return null;
      return WorkoutDraft.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> save(WorkoutDraft draft) async {
    if (!StorageService.isInitialized) return;
    await StorageService.saveString(_key, jsonEncode(draft.toJson()));
  }

  Future<void> clear() async {
    if (!StorageService.isInitialized) return;
    await StorageService.remove(_key);
  }
}
