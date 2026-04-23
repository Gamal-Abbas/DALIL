import 'package:dalil/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  await di.init();

  runApp(const DalilApp());
}

class DalilApp extends StatefulWidget {
  const DalilApp({super.key});

  @override
  State<DalilApp> createState() => _DalilAppState();
}

class _DalilAppState extends State<DalilApp> {
  Locale _locale = const Locale('en'); // ✅ اللغة الأساسية

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale, // 🔥 مهم جدًا
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'DALIL',
      debugShowCheckedModeBanner: false,

      /// 👇 نبعت الفنكشن للشاشة
      home: OnboardingScreen(
        onChangeLocale: _changeLanguage,
      ),
    );
  }
}