import 'package:flutter/material.dart';

import '../constants/app_keys.dart';
import 'storage_service.dart';

class ThemeService extends ChangeNotifier {
  ThemeService._();

  static final instance = ThemeService._();

  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    final stored = StorageService.getString(AppKeys.themeMode);

    _themeMode = switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.dark,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;

    await StorageService.saveString(
      AppKeys.themeMode,
      mode == ThemeMode.light ? 'light' : 'dark',
    );

    notifyListeners();
  }
}
