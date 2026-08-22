import 'package:lift_log/core/utils/app_enums.dart';

class VideoUrlHelper {
  VideoUrlHelper._();

  static Uri? normalize(String? url) {
    final trimmedUrl = url?.trim();
    if (trimmedUrl == null || trimmedUrl.isEmpty) return null;

    final parsedUri = Uri.tryParse(trimmedUrl);
    if (parsedUri == null) return null;

    if (parsedUri.hasScheme) {
      return parsedUri;
    }

    return Uri.tryParse('https://$trimmedUrl');
  }

  static TutorialVideoPlaybackType playbackType(String? url) {
    final uri = normalize(url);
    if (uri == null) return TutorialVideoPlaybackType.invalid;

    if (youtubeVideoId(url) != null) {
      return TutorialVideoPlaybackType.youtube;
    }

    if (_isDirectVideo(uri)) {
      return TutorialVideoPlaybackType.directVideo;
    }

    if (uri.hasScheme && (uri.scheme == 'https' || uri.scheme == 'http')) {
      return TutorialVideoPlaybackType.webPage;
    }

    return TutorialVideoPlaybackType.invalid;
  }

  static String? youtubeVideoId(String? url) {
    final uri = normalize(url);
    if (uri == null) return null;

    final host = uri.host.toLowerCase().replaceFirst('www.', '');
    final segments = uri.pathSegments;

    if (host == 'youtu.be' && segments.isNotEmpty) {
      return _cleanVideoId(segments.first);
    }

    if (host == 'youtube.com' || host == 'music.youtube.com') {
      final watchId = uri.queryParameters['v'];
      if (watchId != null && watchId.isNotEmpty) {
        return _cleanVideoId(watchId);
      }

      if (segments.length >= 2 &&
          (segments.first == 'shorts' || segments.first == 'embed')) {
        return _cleanVideoId(segments[1]);
      }
    }

    return null;
  }

  static bool _isDirectVideo(Uri uri) {
    final path = uri.path.toLowerCase();
    return path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.m4v') ||
        path.endsWith('.webm') ||
        path.endsWith('.m3u8');
  }

  static String? _cleanVideoId(String value) {
    final id = value.split('?').first.split('&').first.trim();
    return id.isEmpty ? null : id;
  }
}
