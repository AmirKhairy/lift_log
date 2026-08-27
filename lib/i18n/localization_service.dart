import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/services/storage_service.dart';
import 'ar_language.dart';
import 'en_language.dart';

class LocalizationService extends ChangeNotifier {
  LocalizationService._();

  static final instance = LocalizationService._();

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Map<String, String> _translations = enLanguage;

  Future<void> init() async {
    final language =
        StorageService.getString(AppConstants.instance.languageKey) ?? 'ar';

    _locale = Locale(language);

    _translations = language == 'ar' ? arLanguage : enLanguage;
  }

  Future<void> changeLanguage(String language) async {
    if (_locale.languageCode == language) return;

    _locale = Locale(language);

    _translations = language == 'ar' ? arLanguage : enLanguage;

    await StorageService.saveString(
      AppConstants.instance.languageKey,
      language,
    );

    notifyListeners();
  }

  String translate(String key) {
    return _translations[key] ?? key;
  }
}
