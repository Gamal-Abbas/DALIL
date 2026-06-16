import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:depi_dalil/features/notifications/presentation/pages/testNotificationview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/theme/theme_extension.dart';
import 'features/profile/presentation/pages/profile_view.dart';
import 'features/settings/presentation/pages/settings_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    // ← هتحط صفحة الهوم هنا
    TestnotiView2(), // ← صفحة الـ Notifications
    SettingsView(),
    ProfileView(),
    // ← صفحة الـ Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: _pages[_currentIndex],
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
              _navItem(
                context,
                index: 0,
                icon: Icons.person_rounded,
                label: 'profile'.tr(),
              ),
              _navItem(
                context,
                index: 1,
                icon: Icons.notifications_rounded,
                label: 'notifications'.tr(),
              ),
              _navItem(
                context,
                index: 2,
                icon: Icons.settings_rounded,
                label: 'settings'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
///////////////
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
              color: isSelected
                  ? context.colorScheme.primary
                  : context.textHint,
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
