import 'package:lift_log/core/utils/app_enums.dart';

class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'required';
    }

    return null;
  }

  static String? name(String? value) {
    if (required(value) != null) {
      return 'required';
    }

    if (value!.length < 3) {
      return 'name_too_short';
    }
    return null;
  }

  static String? email(String? value) {
    if (required(value) != null) {
      return 'required';
    }

    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!regex.hasMatch(value!)) {
      return 'invalid_email';
    }

    return null;
  }

  static String? password(String? value, {bool skip = true}) {
    if (skip) {
      return null;
    }
    if (required(value) != null) {
      return 'required';
    }

    if (value!.length < 6) {
      return 'password_too_short';
    }

    return null;
  }

  static String? age(int? value) {
    if (value == null) {
      return 'Select your age';
    }

    return null;
  }

  static String? gender(Gender? value) {
    if (value == null) {
      return 'Select your gender';
    }

    return null;
  }

  static String? height(double? value) {
    if (value == null) {
      return 'Select your height';
    }

    return null;
  }

  static String? weight(double? value) {
    if (value == null) {
      return 'Select your weight';
    }

    return null;
  }
}
