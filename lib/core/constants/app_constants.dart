import 'dart:ui';

class AppConstants {
  AppConstants._privateConstructor();

  static final AppConstants _instance = AppConstants._privateConstructor();

  static AppConstants get instance => _instance;

  static final locales = const [Locale('ar'), Locale('en')];

  final languages = ['العربية', 'English'];
  String languageKey = 'languageKey';
  static const String appName = 'Lift Log';

  static const double defaultRadius = 16;

  static const Duration animationDuration = Duration(milliseconds: 250);
}
