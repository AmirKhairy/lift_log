import 'dart:developer';

class AppLogger {
  AppLogger._();

  static void info(dynamic message) {
    log(
      message.toString(),
      name: 'INFO',
    );
  }

  static void error(dynamic message) {
    log(
      message.toString(),
      name: 'ERROR',
    );
  }
}