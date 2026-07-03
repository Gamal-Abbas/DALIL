import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'core/theme/theme_extension.dart';
import 'core/theme/text_theme.dart';
import 'features/artifacts_3d/presentation/pages/3dView.dart';
import 'features/notifications/data/datasources/notification_service.dart';
import 'features/notifications/data/repositories/notiication_repo.dart';
import 'features/profile/presentation/manager/currency_cubit.dart';
import 'features/profile/presentation/manager/profile_cubit.dart';
import 'features/profile/presentation/pages/profile_view.dart';
import 'features/qr_code/presentation/pages/qrView.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription<NotificationResponse>? _subscription;
  int _currentIndex = 0;
  static bool _initialNotificationChecked = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUser();
    context.read<CurrencyCubit>().loadCurrency();


    if (!_initialNotificationChecked) {
      _initialNotificationChecked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NotificationService.checkInitialNotification(context);
      });
    }

    _subscription = NotificationRepo.streamController2.stream.listen((event) async {
      if (!mounted) return;
      if (event.payload == null) return;
      await NotificationService.handleNavigation(context, event.payload!);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0: return const ProfileView();
      case 1: return const QRScannerScreen();
      case 2: return  Model3DScreen(
        assetPath: 'assets/3d/ramsis_2/scene_v1.glb',
        title: 'ramsis_2',
      );
      default: return const ProfileView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: _buildPage(_currentIndex),
      bottomNavigationBar: _buildNavBar(context),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, index: 0, icon: Icons.person_rounded, label: 'profile'.tr()),
              _navItem(context, index: 1, icon: Icons.qr_code_scanner_rounded, label: 'qr'.tr()),
              _navItem(context, index: 2, icon: Icons.diamond, label: '3D'.tr()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      BuildContext context, {
        required int index,
        required IconData icon,
        required String label,
      }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? context.colorScheme.primary : context.textHint,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: context.body14?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}