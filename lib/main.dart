import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart' as di;

import 'features/object_detection/object_detection_injection.dart';
import 'features/object_detection/presentation/pages/object_detection_page.dart';
import 'features/object_detection/presentation/cubit/object_detection_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();
  initObjectDetection(); // تهيئة ملفات الـ Object Detection الجديدة

  runApp(const DalilApp());
}

class DalilApp extends StatelessWidget {
  const DalilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DALIL',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => sl<ObjectDetectionCubit>()..initialize(),
        child: const ObjectDetectionPage(),
      ),
    );
  }
}

