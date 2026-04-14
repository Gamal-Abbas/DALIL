import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart' as di;

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
    return MultiBlocProvider(
      providers: [
        // TODO: Add global Blocs/Cubits here using dependency injection
      ],
      child: MaterialApp(title: 'DALIL', debugShowCheckedModeBanner: false),
    );
  }
}
