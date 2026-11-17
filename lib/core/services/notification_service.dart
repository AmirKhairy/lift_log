import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lift_log/core/helpers/logger.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Notification payloads are displayed by FCM when the app is backgrounded
  // or terminated. Data-only messages need a local notification here.
  if (message.notification == null) {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await NotificationService.instance._initializeLocalNotifications(settings);
    await NotificationService.instance._showLocalNotification(message);
  }
}

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  static const String topic = 'app_notification_topic';
  static const String _channelId = 'app_notifications';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  Future<bool>? _permissionRequest;

  Future<void> initialize() async {
    if (_initialized) return;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _initializeLocalNotifications(settings);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    _initialized = true;
  }

  Future<bool> requestPermissionAndSubscribe() {
    return _permissionRequest ??= _requestPermissionAndSubscribe();
  }

  Future<bool> _requestPermissionAndSubscribe() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      final isAllowed =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (!isAllowed) return false;

      await _messaging.subscribeToTopic(topic);
      return true;
    } catch (error, stackTrace) {
      AppLogger.error('Notification setup failed: $error');
      AppLogger.error(stackTrace);
      return false;
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    // iOS displays notification payloads through the foreground presentation
    // options configured below. Showing another local notification would
    // duplicate the alert.
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        message.notification != null) {
      return;
    }

    await _showLocalNotification(message);
  }

  Future<void> _initializeLocalNotifications(
    InitializationSettings settings,
  ) async {
    await _localNotifications.initialize(settings: settings);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            'App notifications',
            description: 'Notifications sent by Bulkito.',
            importance: Importance.high,
          ),
        );
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final dataTitle = message.data['title']?.toString();
    final dataBody = message.data['body']?.toString();
    final title = notification?.title ?? dataTitle;
    final body = notification?.body ?? dataBody;

    if (title == null && body == null) return;

    await _localNotifications.show(
      id: message.messageId?.hashCode ?? DateTime.now().hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'App notifications',
          channelDescription: 'Notifications sent by Bulkito.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
