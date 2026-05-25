import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/constants/cash.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/data/repositories/auth_Repo.dart';
import 'features/auth/presentation/manager/authBloc.dart';
import 'features/notifications/data/repositories/notiication_repo.dart';
import 'features/notifications/domain/usecases/work_manager_service.dart';
import 'features/profile/presentation/manager/profile_cubit.dart';
import 'firebase_options.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  tz.initializeTimeZones();

  // ***** =>>>>> ~~~~~      Ziad Taha     ~~~~~ <<<<<=***** //
  // All Wait Time To Run App Is Max(1,2,3) Lead to it wait only 3 seconds

  final plugin = NotificationRepo.flutterLocalNotificationsPlugin;
  plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();
  await Future.wait([
    // NotificationRepo.init(),
    cash.initialpref(),
    EasyLocalization.ensureInitialized(),
    NotificationRepo.init(), // 1 sec
    WorkManagerService().init(), // 2 sec
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
  String? savedLang = await cash.getLang();
  // savedLang='en';
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      startLocale: savedLang.isNotEmpty
          ? Locale(savedLang)
          : const Locale('en'),
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(
            create: (context) => authBloc(repository: AuthRepo())..autoLogin(),
          ),
          BlocProvider(create: (_) => ProfileCubit()..getUser()),
        ],
        child: const MyApp(),
      ),
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
        // return MaterialApp(
        //   navigatorKey: navigatorKey,
        //
        //   localizationsDelegates: context.localizationDelegates,
        //   supportedLocales: context.supportedLocales,
        //   locale: context.locale,
        //
        //   useInheritedMediaQuery: true,
        //   builder: DevicePreview.appBuilder,
        //   debugShowCheckedModeBanner: false,
        //   home: QRScannerScreen(),
        // );
        return BlocBuilder<ThemeCubit, bool>(
          builder: (context, isDark) {
            return MaterialApp(
              theme: AppTheme.lightTheme(context),
              darkTheme: AppTheme.darkTheme(context),
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              navigatorKey: navigatorKey,

              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,

              useInheritedMediaQuery: true,
              builder: DevicePreview.appBuilder,
              debugShowCheckedModeBanner: false,
              home: Home(),
              // home: BlocBuilder<authBloc, Authstate>(
              //   builder: (context, state) {
              //     if (state is AuthSuccess) {
              //       return const Home();
              //     }
              //
              //     if (state is AuthInitial) {
              //       return const Splash();
              //     }
              //
              //     return Loginview();
              //   },
              // ),
            );
          },
        );
      },
    );
  }
}
