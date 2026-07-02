
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../../../../core/constants/cash.dart';
import '../../data/repositories/notiication_repo.dart';
import 'firebase_service.dart';

@pragma('vm:entry-point')
void action() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      tz.initializeTimeZones();
      await Firebase.initializeApp();

      await cash.initialPref();
      final lang = cash.getLang();
      print('Background Lang: $lang');
      final enabled = cash.pref.getBool('notifications_enabled') ?? true;
      if (!enabled) {
        print('🔕 Notifications disabled - skipping');
        return Future.value(true);
      }

      await NotificationRepo.init();
      await FirebaseService.retrieveRandom_Id_FromFirebase();

      return Future.value(true);
    } catch (e) {
      print("Error in Background: $e");
      return Future.value(false);
    }
  });
}

class WorkManagerService {
  static void registerTask() {
    Workmanager().registerPeriodicTask(
      'id1',
      'registerTask',
      frequency: Duration(seconds: 10),
      constraints: Constraints(
        requiresCharging: false,
        requiresBatteryNotLow: false,
        requiresStorageNotLow: false,
        networkType: NetworkType.connected,
      ),
    );
  }

  Future<void> init() async {
    await Workmanager().initialize(action, isInDebugMode: true);

    WorkManagerService.registerTask();
  }

  Future<void> cancelWorkManager() async {
    await Workmanager().cancelAll();
  }
}