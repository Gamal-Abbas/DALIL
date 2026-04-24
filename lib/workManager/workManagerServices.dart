import 'package:dalil/notifications/notifications2/firebaseManager.dart';
import 'package:dalil/notifications/notifications2/notificationManager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void action() {
  Workmanager().executeTask((taskName, inputData) async {


    try {
      print("Background Task Started Successfully!");
      WidgetsFlutterBinding.ensureInitialized();
      tz.initializeTimeZones();
      await Firebase.initializeApp();
      await NotificationManager.init();


      await FireBaseManager.retrieveDataFromFirebase();


      return Future.value(true);
    } catch (e) {
      print("Error in Background: $e");
      return Future.value(false);
    }
  });
}

class Workmanagerservices {
  static void registerTask()  {
     Workmanager().registerPeriodicTask(
      'id1',
      'registerTask',
      frequency: Duration(seconds: 10),
       constraints: Constraints(
         requiresCharging: false,
         requiresBatteryNotLow: false,
         requiresStorageNotLow: false,
         networkType: NetworkType.connected
       )

    );
  }

  Future<void> init() async {
    await Workmanager().initialize(action, isInDebugMode: true);

      Workmanagerservices.registerTask();
  }

  Future<void> cancelWorkManager() async {
    await Workmanager().cancelByUniqueName('id1');
  }
}
