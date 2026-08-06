import 'dart:developer';

import 'package:lift_log/core/extensions/localization_extension.dart';

class AppLogger {
  AppLogger._();

  static void info(dynamic message) {
    log(message.toString(), name: 'info'.tr);
  }

  static void error(dynamic message) {
    log(message.toString(), name: 'error'.tr);
  }
}
