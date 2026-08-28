import 'package:image_picker/image_picker.dart';
import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/models/machine_model.dart';
import 'package:lift_log/core/services/supabase_service.dart';
import 'package:lift_log/core/utils/app_enums.dart';

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

  Future<MachineModel> addMachine({
    required String name,
    required String notes,
    required MuscleGroup muscleGroup,
    required XFile image,
    String? tutorialVideoId,
  }) async {
    try {
      final userId = SupabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User is not logged in');
      }

      final imageUrl = await _uploadMachineImage(userId: userId, image: image);

      final response = await SupabaseService.client
          .from('machines')
          .insert({
            'user_id': userId,
            'name': name.trim(),
            'image_url': imageUrl,
            'muscle_group': muscleGroup.toJson(),
            'tutorial_video_id': tutorialVideoId,
            'notes': notes.trim().isEmpty ? null : notes.trim(),
          })
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
          .single();

      final machine = MachineModel.fromJson(response);
      machines = [machine, ...?machines];

      return machine;
    } catch (e) {
      throw Exception('Failed to add machine: $e');
    }
  }

  static const _machineSelect = '''
          id,
          user_id,
          name,
          image_url,
          muscle_group,
          tutorial_video_id,
          notes,
          created_at,
          updated_at
        ''';

  Future<MachineModel> updateMachine({
    required MachineModel machine,
    required String name,
    required String notes,
    required MuscleGroup muscleGroup,
    String? tutorialVideoId,
    XFile? image,
  }) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      final machineId = machine.id;

      if (userId == null) {
        throw Exception('User is not logged in');
      }

      if (machineId == null) {
        throw Exception('Machine is invalid');
      }

      var imageUrl = machine.imageUrl;
      if (image != null) {
        imageUrl = await _uploadMachineImage(userId: userId, image: image);
      }

      final response = await SupabaseService.client
          .from('machines')
          .update({
            'name': name.trim(),
            'image_url': imageUrl,
            'muscle_group': muscleGroup.toJson(),
            'tutorial_video_id': tutorialVideoId,
            'notes': notes.trim().isEmpty ? null : notes.trim(),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', machineId)
          .eq('user_id', userId)
          .select(_machineSelect)
          .single();

      if (image != null) {
        final oldImagePath = _machineImagePath(machine.imageUrl);
        if (oldImagePath != null) {
          await SupabaseService.client.storage.from('machine-images').remove([
            oldImagePath,
          ]);
        }
      }

      final updated = MachineModel.fromJson(response);
      machines = [
        for (final item in machines ?? const <MachineModel>[])
          if (item.id == machineId) updated else item,
      ];

      return updated;
    } catch (e) {
      throw Exception('Failed to update machine: $e');
    }
  }

  Future<void> deleteMachine(String machineId, {String? imageUrl}) async {
    try {
      final userId = SupabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User is not logged in');
      }

      await SupabaseService.client
          .from('machines')
          .delete()
          .eq('id', machineId)
          .eq('user_id', userId);

      final imagePath = _machineImagePath(imageUrl);
      if (imagePath != null) {
        await SupabaseService.client.storage.from('machine-images').remove([
          imagePath,
        ]);
      }

      machines = machines?.where((machine) => machine.id != machineId).toList();
    } catch (e) {
      throw Exception('Failed to delete machine: $e');
    }
  }

  String? _machineImagePath(String? imageUrl) {
    if (imageUrl == null || imageUrl.trim().isEmpty) return null;

    final segments = Uri.tryParse(imageUrl)?.pathSegments;
    if (segments == null) return null;

    final bucketIndex = segments.indexOf('machine-images');
    if (bucketIndex == -1 || bucketIndex == segments.length - 1) return null;

    return segments.sublist(bucketIndex + 1).join('/');
  }

  Future<String> _uploadMachineImage({
    required String userId,
    required XFile image,
  }) async {
    final bytes = await image.readAsBytes();
    final extension = image.name.split('.').lastOrNull ?? 'jpg';
    final path = '$userId/${DateTime.now().millisecondsSinceEpoch}.$extension';

    await SupabaseService.client.storage
        .from('machine-images')
        .uploadBinary(path, bytes);

    return SupabaseService.client.storage
        .from('machine-images')
        .getPublicUrl(path);
  }
}
