import 'package:lift_log/core/services/supabase_service.dart';
import 'package:lift_log/core/models/user_model.dart';

class UserService {
  UserService._();

  static final instance = UserService._();

  UserModel? _user;

  UserModel? get user => _user;

  Future<UserModel> getUserData() async {
    final userId = SupabaseService.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final response = await SupabaseService.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    final user = UserModel.fromJson(response);

    _user = user;

    return user;
  }

  Future<UserModel> updateProfile({
    required String name,
    required int age,
    required String gender,
    required double height,
    required double weight,
  }) async {
    final userId = SupabaseService.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final response = await SupabaseService.client
        .from('profiles')
        .update({
          'name': name,
          'age': age,
          'gender': gender,
          'height': height,
          'weight': weight,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId)
        .select()
        .single();

    final user = UserModel.fromJson(response);

    _user = user;

    return user;
  }

  void clearUser() {
    _user = null;
  }
}
