import 'package:depi_dalil/core/constants/app_color.dart';
import 'package:depi_dalil/features/profile/presentation/pages/profile_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/cash.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/utils/size.dart';
import '../../../auth/presentation/manager/authBloc.dart';
import '../../../auth/presentation/pages/loginView.dart';
import '../widgets/settings_tile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final SH = context.screenHeight;
    final SW = context.screenWidth;
    final isDark = context.watch<ThemeCubit>().state;

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: Text('settings'.tr(),style: context.title20,),
        backgroundColor: context.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(

            Icons.arrow_back_ios_new,
            color: context.iconColor,
            size: (SH / 21).clamp(20, 45),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.screenWidth / 18,
          vertical: context.screenHeight / 40,
        ),
        child: Column(
          spacing: context.screenHeight / 75,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('profile'.tr(), style: context.body14),
            SettingsTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) {
                      return ProfileView();
                    },
                  ),
                );
              },
              icon: Icons.person,
              title: 'profile'.tr(),
              trailing: Icon(


                Icons.arrow_forward_ios,
                size: 16,
                color: context.textHint,
              ),
            ),

            Text('appearance'.tr(), style: context.body14),
            SettingsTile(
              icon: isDark ? Icons.dark_mode : Icons.light_mode,
              title: 'darkMode'.tr(),

              trailing: Switch(
                value: isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              ),
            ),

            Text('language'.tr(), style: context.body14),
            SettingsTile(
              icon: Icons.language,
              title: 'language'.tr(),
              subtitle: context.locale.languageCode == 'ar'
                  ? 'العربية'
                  : 'English',
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: context.textHint,
              ),
              onTap: () => _showLanguageSheet(context),
            ),

            Text('account'.tr(), style: context.body14),
            SettingsTile(
              icon: Icons.logout,
              title: 'logout'.tr(),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: context.textHint,
              ),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  // ── Language Bottom Sheet ──
  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.textHint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _langOption(context, 'English', 'en'),
            const SizedBox(height: 12),
            _langOption(context, 'العربية', 'ar'),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _langOption(BuildContext context, String label,
      String code)
  {
    final isSelected = context.locale.languageCode == code;
    return GestureDetector(
      onTap: () async {
        await context.setLocale(Locale(code));
        await cash.setLang(code);
        if (context.mounted) Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary.withOpacity(0.1)
              : context.scaffoldBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.textHint.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: context.body16),
            if (isSelected)
              Icon(Icons.check, ),
          ],
        ),
      ),
    );
  }

  // ── Logout Dialog ──
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('logout'.tr(), style: context.headline30),
        content: Text('logoutConfirm'.tr(), style: context.body18),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel'.tr(),

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
              style: context.body16?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
