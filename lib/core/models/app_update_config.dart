import 'dart:io';

class AppUpdateConfig {
  const AppUpdateConfig({required this.minimumVersion, required this.storeUrl});

  final String minimumVersion;
  final String storeUrl;

  factory AppUpdateConfig.fromMap(Map<String, dynamic> map) {
    final minimumVersion = Platform.isIOS
        ? map['minimum_ios_version']
        : map['minimum_android_version'];
    final storeUrl = Platform.isIOS
        ? map['ios_store_url']
        : map['android_store_url'];

    return AppUpdateConfig(
      minimumVersion: minimumVersion?.toString() ?? '',
      storeUrl: storeUrl?.toString() ?? '',
    );
  }

  bool requiresUpdate(String currentVersion) {
    return compareVersions(currentVersion, minimumVersion) < 0;
  }

  static int compareVersions(String first, String second) {
    final firstParts = _parts(first);
    final secondParts = _parts(second);
    final length = firstParts.length > secondParts.length
        ? firstParts.length
        : secondParts.length;

    for (var index = 0; index < length; index++) {
      final firstPart = index < firstParts.length ? firstParts[index] : 0;
      final secondPart = index < secondParts.length ? secondParts[index] : 0;
      if (firstPart != secondPart) return firstPart.compareTo(secondPart);
    }

    return 0;
  }

  static List<int> _parts(String version) {
    return version
        .split('+')
        .first
        .split('.')
        .map((part) => int.tryParse(part) ?? 0)
        .toList();
  }
}
