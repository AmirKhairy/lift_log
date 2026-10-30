import 'package:flutter_test/flutter_test.dart';
import 'package:lift_log/core/models/app_update_config.dart';

void main() {
  group('AppUpdateConfig.compareVersions', () {
    test('compares semantic versions numerically', () {
      expect(AppUpdateConfig.compareVersions('1.10.0', '1.9.0'), greaterThan(0));
      expect(AppUpdateConfig.compareVersions('2.0.0', '2.0.0'), 0);
      expect(AppUpdateConfig.compareVersions('1.2.3+4', '1.2.4'), lessThan(0));
    });
  });
}
