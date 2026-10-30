import 'package:lift_log/core/models/app_update_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../supabase_service.dart';

class AppUpdateService {
  AppUpdateService._();

  static final instance = AppUpdateService._();

  AppUpdateConfig? _requiredUpdate;
  String _currentVersion = '';

  AppUpdateConfig? get requiredUpdate => _requiredUpdate;

  String get currentVersion => _currentVersion;

  Future<void> checkForRequiredUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;
      final response = await SupabaseService.client
          .from('app_settings')
          .select(
            'minimum_android_version, minimum_ios_version, '
            'android_store_url, ios_store_url',
          )
          .eq('id', 1)
          .maybeSingle()
          .timeout(const Duration(seconds: 5));

      if (response == null) return;

      final config = AppUpdateConfig.fromMap(response);
      if (config.minimumVersion.isEmpty || config.storeUrl.isEmpty) return;

      if (config.requiresUpdate(packageInfo.version)) {
        _requiredUpdate = config;
      }
    } catch (e) {
      print('Failed to check for required update: $e');
    }
  }
}
