import 'dart:async';
import 'dart:convert';
import 'package:dalil/features/ArtifactDetails/data/model/baseModel.dart';
import 'package:dalil/features/ArtifactDetails/data/model/eraModel.dart';
import 'package:dalil/features/ArtifactDetails/view/dispatcher.dart';
import 'package:dalil/main.dart';
import 'package:dalil/notifications/notifications2/firebaseManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {

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


  static Future<void> checkInitialNotification(BuildContext context) async {
    final NotificationAppLaunchDetails? launchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
      final response = launchDetails.notificationResponse;

      if (response != null && response.payload != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          handleNavigation(context, response.payload!);
        });
      }
    }
  }


  static Future<void> handleNavigation(
    BuildContext context,
    String payload,
  ) async {
    print("NAVIGATING WITH PAYLOAD: $payload");

    String id;
    String type;

    if (payload.contains('|')) {
      var parts = payload.split('|');
      id = parts[0];
      type = parts[1];
    } else {

      final decoded = jsonDecode(payload);
      id = decoded['id'];
      type = decoded['type'];
    }

    final data = await FireBaseManager.getSpecificData(id: id);
    if (data == null) return;

    // final baseModel = BaseModel.fromJson(data);
    BaseModel model;
    if (data['collectionType'] == 'eras') {
      model = EraModel.fromJson(data);
    } else {
      model = BaseModel.fromJson(data);
    }
    print('Model=$model');

    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => ArtifactDetailsScreen(data: model)),
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => ArtifactDetailsScreen(data: baseModel)),
    // );
  }


  static Future startDailyscheduled({
    required String title,
    required String body,
    required String payload,
    required String lang,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        enableVibration: true,


        'dalil_Daily_channel_id',
        'DALIL Notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        // ledColor: Colors.red,
        // colorized: true,
        // color: Colors.green
        color: Colors.yellow,
        colorized: true,

      );

      final details = NotificationDetails(android: androidDetails);

      var location = tz.getLocation('Africa/Cairo');
      var currentTime = tz.TZDateTime.now(location);

      var scheduledTime = tz.TZDateTime.now(
        location,
      ).add(const Duration(seconds: 10));

      //   var scheduledTime=
      //        tz.TZDateTime(
      //            location,
      //          currentTime.year,
      //          currentTime.month,
      //          currentTime.day,
      //          currentTime.hour,
      //          24
      //
      // );

      if (scheduledTime.isBefore(currentTime)) {
        scheduledTime = scheduledTime.add(const Duration(hours: 1));
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: lang=='ar'? '\u202B'+title:title,
        body: lang=='ar'? '\u202B'+body:body,
        notificationDetails: details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        scheduledDate: scheduledTime,
      );

      print('========== Notification Scheduled ==========');
      print(title);
      print(body);
      print(payload);
      print('===========================================');
    } catch (e) {
      print("Schedule Error: $e");
    }
  }
}
