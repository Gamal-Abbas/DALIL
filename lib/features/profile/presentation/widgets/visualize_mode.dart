import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../../main.dart';
import '../../../auth/presentation/manager/authBloc.dart';
import '../../../auth/presentation/pages/loginView.dart';
import '../manager/profile_cubit.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector();

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;
    final width = context.screenWidth;

    return RepaintBoundary(
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) => Padding(
          padding: EdgeInsets.all(width / 24),
          child: Row(
            children: [
              ThemeModeCard(
                bgColor: const Color(0xFF1A1A1A),
                lineColor: Colors.white24,
                lineColorSecond: Colors.white12,
                isSelected: isDark,
                onTap: () {
                  if (!isDark) context.read<ThemeCubit>().toggleTheme();
                },
              ),
              SizedBox(width: width / 32),
              ThemeModeCard(
                bgColor: const Color(0xFFE5E2E1),
                lineColor: Colors.black26,
                lineColorSecond: Colors.black12,
                isSelected: !isDark,
                onTap: () {
                  if (isDark) context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeModeLabels extends StatelessWidget {
  const ThemeModeLabels({super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;

    return RepaintBoundary(
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) => Padding(
          padding: EdgeInsets.only(bottom: width / 32),
          child: Row(
            children: [
              ThemeModeText(text: 'Dark'.tr(), isSelected: isDark),
              ThemeModeText(text: 'Light'.tr(), isSelected: !isDark),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeModeCard extends StatelessWidget {
  final Color bgColor;
  final Color lineColor;
  final Color lineColorSecond;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemeModeCard({
    required this.bgColor,
    required this.lineColor,
    required this.lineColorSecond,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;
    final width = context.screenWidth;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height / 8,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(width / 32),
            border: Border.all(
              color: isSelected
                  ? context.colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PreviewLine(color: lineColor, width: width / 6, height: height / 140),
              _PreviewLine(color: lineColorSecond, width: width / 9, height: height / 200),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const _PreviewLine({required this.color, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth / 24,
        vertical: screenWidth / 80,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class ThemeModeText extends StatelessWidget {
  final String text;
  final bool isSelected;

  const ThemeModeText({required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: context.body14?.copyWith(
          color: isSelected ? context.colorScheme.primary : context.textHint,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton();

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;
    final width = context.screenWidth;

    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: height / 55),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(width / 24),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red, size: width / 20),
            SizedBox(width: width / 40),
            Text(
              'logout'.tr(),
              style: context.body18?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final width = context.screenWidth;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width / 20),
        ),
        title: Text('logout'.tr(), style: context.title27),
        content: Text('logoutConfirm'.tr(), style: context.body16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel'.tr(),
              style: context.body16?.copyWith(color: context.textHint),
            ),
          ),
          TextButton(
            onPressed: () async {
              final profileCubit = context.read<ProfileCubit>();
              final bloc = context.read<authBloc>();

              profileCubit.reset();
              await bloc.signOut();

              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Loginview()),
                    (route) => false,
              );
            },
            child: Text(
              'logout'.tr(),
              style: context.body16?.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}