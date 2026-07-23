import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  Size get size => MediaQuery.sizeOf(this);

  double get width => size.width;

  double get height => size.height;

  bool get isDark => theme.brightness == Brightness.dark;

  void unfocus() {
    FocusScope.of(this).unfocus();
  }
}
