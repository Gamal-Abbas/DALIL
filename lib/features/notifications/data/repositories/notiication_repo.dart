import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationRepo {
  static StreamController<NotificationResponse> streamController2 =
      StreamController<NotificationResponse>.broadcast();

  static void onRecieve(NotificationResponse response) {
    streamController2.add(response);
  }

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveBackgroundNotificationResponse: onRecieve,
      onDidReceiveNotificationResponse: onRecieve,
    );
  }
}
