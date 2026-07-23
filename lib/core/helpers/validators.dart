class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'required';
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
}