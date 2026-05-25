import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../auth/presentation/manager/authBloc.dart';
import '../../../auth/presentation/pages/loginView.dart';

class VisualMode extends StatelessWidget {
  const VisualMode();

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;

    return RepaintBoundary(
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) => Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ModeOption(
                bgColor: const Color(0xFF1A1A1A),
                lineColor: Colors.white24,
                lineColorSecond: Colors.white12,
                isSelected: isDark,
                height: height,
                onTap: () {
                  if (!isDark) context.read<ThemeCubit>().toggleTheme();
                },
              ),
              const SizedBox(width: 12),
              ModeOption(
                bgColor: const Color(0xFFE5E2E1),
                lineColor: Colors.black26,
                lineColorSecond: Colors.black12,
                isSelected: !isDark,
                height: height,
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

// ✅ الـ Labels منفصلة عن الـ BlocBuilder عشان متعملش rebuild معاه
class VisualModeLabels extends StatelessWidget {
  const VisualModeLabels();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              ModeLabel(text: 'Dark', isSelected: isDark),
              ModeLabel(text: 'Light', isSelected: !isDark),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ بدل تكرار NOX/LUX
class ModeOption extends StatelessWidget {
  final Color bgColor;
  final Color lineColor;
  final Color lineColorSecond;
  final bool isSelected;
  final double height;
  final VoidCallback onTap;

  const ModeOption({
    required this.bgColor,
    required this.lineColor,
    required this.lineColorSecond,
    required this.isSelected,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height / 8,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
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
              _Line(color: lineColor, width: 60, height: 6),
              _Line(color: lineColorSecond, width: 40, height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ بدل تكرار الـ Container بتاع الخطوط
class _Line extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const _Line({required this.color, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// ✅ بدل تكرار الـ Text بتاع Dark/Light
class ModeLabel extends StatelessWidget {
  final String text;
  final bool isSelected;

  const ModeLabel({required this.text, required this.isSelected});

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























// ✅ Deactivate منفصلة
class LogOutButton extends StatelessWidget {


  const LogOutButton();

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;

    return GestureDetector(
      onTap: (){
        _showLogoutDialog(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: height / 55),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: Colors.red, size: 20),
            const SizedBox(width: 10),
            Text(
              'LogOut',
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              await context.read<authBloc>().signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Loginview()),
                      (route) => false,
                );
              }
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
