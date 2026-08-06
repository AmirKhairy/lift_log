import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  User? get currentUser => _client.auth.currentUser;

  Future<User> login({required String email, required String password}) async {
    try {
      final authResult = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return authResult.user!;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> loginWithGoogle() async {
    try {
      final webClientId = dotenv.env['WEB_CLIENT_ID'] ?? '';

      final iosClientId = dotenv.env['IOS_CLIENT_ID'] ?? '';

      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleAccount = await signIn.authenticate();

      final googleAuthentication = googleAccount.authentication;
      final idToken = googleAuthentication.idToken;

      if (idToken == null) {
        throw 'no_id_token'.tr;
      }

      final authResult = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      return authResult.user!;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isProfileCompleted(String userId) async {
    try {
      final profile = await _client
          .from('profiles')
          .select('age')
          .eq('id', userId)
          .maybeSingle();

      if (profile == null) return false;

      return profile['age'] != null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required int age,
    required double height,
    required double weight,
    required String gender,
  }) async {
    try {
      final authResult = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'age': age,
          'height': height,
          'weight': weight,
          'gender': gender,
        },
      );

      return authResult.user!;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerWithGoogle({
    required String userId,
    required int age,
    required double height,
    required double weight,
    required String gender,
  }) async {
    try {
      await _client
          .from('profiles')
          .update({
            'age': age,
            'height': height,
            'weight': weight,
            'gender': gender,
          })
          .eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendResetPasswordEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'liftlog://reset-password',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: password));
    } catch (e) {
      rethrow;
    }
  }
}
