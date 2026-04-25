import 'package:dalil/core/bloc/auth/authBloc.dart';
import 'package:dalil/core/constants/cash.dart';
import 'package:dalil/features/QR/view/qrView.dart';
import 'package:dalil/notifications/notifications2/notificationManager.dart';
import 'package:dalil/notifications/notifications2/testNotificationview.dart';
import 'package:dalil/workManager/workManagerServices.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // ***** =>>>>> ~~~~~      Ziad Taha     ~~~~~ <<<<<=***** //
  // All Wait Time To Run App Is Max(1,2,3) Lead to it wait only 3 seconds

  final plugin = NotificationManager.flutterLocalNotificationsPlugin;
  plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();
  await Future.wait([
    cash.initialpref(),
    EasyLocalization.ensureInitialized(),
    NotificationManager.init(), // 1 sec
    Workmanagerservices().init(), // 2 sec
    Firebase.initializeApp(
      // 3 sec
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);

  // All Wait Time To Run App Is Sum(1,2,3)
  // = 1+2+3=6
  // Lead to it wait 6 Seconds
  //   await myNotifications.init();           // 1 sec
  //   await Workmanagerservices().init();    // 2 sec
  //   await Firebase.initializeApp(         // 3 sec
  //       options: DefaultFirebaseOptions.currentPlatform);
  String? savedLang = cash.getLang();
  // savedLang='en';
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      startLocale: savedLang.isNotEmpty ? Locale(savedLang) : const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: true,
      builder: (context) {
        return BlocProvider(
          create: (context) => authBloc(),
          child: MaterialApp(
            navigatorKey: navigatorKey,


            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,

            // locale: DevicePreview.locale(context),
            //
            // supportedLocales: AppLocalizations.supportedLocales,
            // localizationsDelegates: const [
            //   AppLocalizations.delegate,
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],

            useInheritedMediaQuery: true,
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            home:  QRScannerScreen(),
          ),
        );
      },
    );
  }
}
