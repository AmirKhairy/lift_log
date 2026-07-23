extension StringExtension on String {
  bool get isEmail {
    return RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    ).hasMatch(this);
  }

  String get capitalize {
    if (isEmpty) return this;

    return this[0].toUpperCase() + substring(1);
  }
}