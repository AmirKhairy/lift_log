import 'package:flutter/material.dart';

import '../theme/app_theme_extension.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get text => theme.textTheme;

  AppThemeExtension get appColors =>
      theme.extension<AppThemeExtension>() ??
      AppThemeExtension(
        subtitle: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        border: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        success: Colors.green,
        warning: Colors.orange,
      );

  bool get isDark => theme.brightness == Brightness.dark;
}
