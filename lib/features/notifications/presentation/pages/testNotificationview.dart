import 'dart:async';


import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/constants/cash.dart';
import '../../data/repositories/notiication_repo.dart';
import '../../domain/usecases/firebase_service.dart';
import '../../domain/usecases/notification_service.dart';

class TestnotiView2 extends StatefulWidget {
  const TestnotiView2({super.key});

  @override
  State<TestnotiView2> createState() => _TestnotiView2State();
}

class _TestnotiView2State extends State<TestnotiView2> {
  StreamSubscription<NotificationResponse>? subscription;

  void onMessTap() {
    subscription = NotificationRepo.streamController2.stream.listen((
      event,
    ) async {
      if (!mounted) return;
      if (event.payload == null) return;

      print('RAW PAYLOAD RECEIVED: ${event.payload}');

      await NotificationService.handleNavigation(context, event.payload!);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    onMessTap();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.checkInitialNotification(context);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            ListTile(
              title: Text('startDailyscheduled Notification',
              style: context.textTheme.bodyLarge,
              ),
              onTap: () async {
                await FirebaseService.retrieveRandom_Id_FromFirebase();
              },
              trailing: ElevatedButton.icon(
                onPressed: () async {},
                label: Icon(Icons.close),
              ),
            ),

            Builder(
              builder: (context) {
                bool isEn =
                    Localizations.localeOf(context).languageCode == 'en';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: () async {
                      String newLang = context.locale.languageCode == 'ar'
                          ? 'en'
                          : 'ar';

                      await context.setLocale(Locale(newLang));

                      await cash.setLang(newLang);

                      Intl.defaultLocale = newLang;

                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 140,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFD700).withOpacity(0.3),
                        ),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            alignment: isEn
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 70,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'EN',
                                    style: TextStyle(
                                      color: isEn ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'AR',
                                    style: TextStyle(
                                      color: isEn ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
