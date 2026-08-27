import 'package:flutter/material.dart';
import 'package:lift_log/i18n/localization_service.dart';

class LogicUtilities {
  LogicUtilities._();

  static final LogicUtilities instance = LogicUtilities._();

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }

  bool isArabicLanguage() {
    return LocalizationService.instance.locale.languageCode == 'ar';
  }

  String formatDateTime(DateTime value, BuildContext context) {
    final date = MaterialLocalizations.of(context).formatMediumDate(value);
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(value));
    return '$date, $time';
  }
}
