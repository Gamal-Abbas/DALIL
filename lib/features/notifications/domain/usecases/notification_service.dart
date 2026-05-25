import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../main.dart';
import '../../../artifacts_3d/data/models/baseModel.dart';
import '../../../artifacts_3d/data/models/eraModel.dart';
import '../../../artifacts_3d/presentation/pages/dispatcher.dart';
import '../../data/repositories/notiication_repo.dart';
import 'firebase_service.dart';

class NotificationService {
  static Future<void> checkInitialNotification(BuildContext context) async {
    final NotificationAppLaunchDetails? launchDetails = await NotificationRepo
        .flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

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

    final data = await FirebaseService.getDataFromFirebase_By_Id(id: id);
    if (data == null) return;

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

      await NotificationRepo.flutterLocalNotificationsPlugin.zonedSchedule(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: lang == 'ar' ? '\u202B' + title : title,
        body: lang == 'ar' ? '\u202B' + body : body,
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
