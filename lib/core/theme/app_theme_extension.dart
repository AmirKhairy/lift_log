import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color subtitle;
  final Color border;
  final Color success;
  final Color warning;

  const AppThemeExtension({
    required this.subtitle,
    required this.border,
    required this.success,
    required this.warning,
  });

  @override
  AppThemeExtension copyWith({
    Color? subtitle,
    Color? border,
    Color? success,
    Color? warning,
  }) {
    return AppThemeExtension(
      subtitle: subtitle ?? this.subtitle,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;

    return AppThemeExtension(
      subtitle: Color.lerp(subtitle, other.subtitle, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}
