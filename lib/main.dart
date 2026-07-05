import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart' as di;

import 'features/smart_itinerary/presentation/pages/smart_itinerary_page.dart';

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
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFD4AF37),
        useMaterial3: true,
      ),
      home: const SmartItineraryPage(),
    );
  }
}
