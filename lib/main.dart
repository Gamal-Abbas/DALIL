import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dalil/core/theme/app_theme.dart';
import 'package:dalil/core/di/injection_container.dart' as di;
import 'package:dalil/features/safety_compass/presentation/pages/safety_compass_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const DalilApp());
}

class DalilApp extends StatelessWidget {
  const DalilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DALIL',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const SafetyCompassPage(),
    );
  }
}
