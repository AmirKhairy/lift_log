import 'package:lift_log/i18n/localization_service.dart';

extension LocalizationExtension on String {
  String get tr {
    return LocalizationService.instance.translate(this);
  }
}
