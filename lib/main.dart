import 'package:dalil/features/ai_guide/presentation/pages/ai_guide_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart' as di;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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
      home: const AiGuidePage(),
    );
  }
}
