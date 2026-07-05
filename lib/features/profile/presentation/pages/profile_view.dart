import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:depi_dalil/features/profile/presentation/widgets/profile_header.dart';
import 'package:depi_dalil/features/profile/presentation/widgets/visualize_mode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../notifications/presentation/manager/notification_cubit.dart';
import '../../data/models/user_model.dart';
import '../manager/currency_cubit.dart';
import '../manager/profile_cubit.dart';
import '../widgets/card.dart';
import '../widgets/profile_dialoge.dart';
import '../widgets/tile.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileBody();
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: context.colorScheme.primary,
              ),
            );
          }
          if (state is ProfileError) {
            return Center(child: Text('error'.tr(), style: context.body18));
          }
          if (state is ProfileLoaded) {
            return _BodyContent(user: state.user);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _BodyContent extends StatelessWidget {
  final UserModel user;

  const _BodyContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;
    final width = context.screenWidth;
    final labelPadding = width / 40;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: height / 10),
          const ProfileHeader(),
          SizedBox(height: height / 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel(context, 'ACCOUNT PREFERENCES'.tr(), labelPadding),
                ProfileCard(
                  children: [
                    Tile(
                      icon: Icons.person_outline,
                      title: 'Personal Information'.tr(),
                      onTap: () => ProfileDialog.showEditNameDialog(
                        context: context,
                        currentName: user.name,
                      ),
                    ),
                    _divider(context),
                    Tile(
                      icon: Icons.language,
                      title: 'Language'.tr(),
                      subtitle: context.locale.languageCode == 'ar'
                          ? 'العربية'
                          : 'English (US)',
                      onTap: () =>
                          ProfileDialog.showLanguageSheet(context: context),
                    ),
                  ],
                ),

                SizedBox(height: height / 40),

                _sectionLabel(context, 'SECURITY & PRIVACY'.tr(), labelPadding),
                ProfileCard(
                  children: [
                    Tile(
                      icon: Icons.shield_outlined,
                      title: 'Two-Factor Authentication'.tr(),
                      onTap: () {},
                    ),
                    _divider(context),
                    Tile(
                      icon: Icons.lock_outline,
                      title: 'Change Encryption Keys'.tr(),
                      onTap: () => ProfileDialog.showChangePasswordDialog(
                          context: context),
                    ),
                  ],
                ),

                SizedBox(height: height / 40),

                ProfileCard(
                  children: [
                    Tile(
                      icon: Icons.notifications_outlined,
                      title: 'Push Notifications'.tr(),
                      subtitle: 'Enable critical artifact updates'.tr(),
                      trailing: RepaintBoundary(
                        child: BlocBuilder<NotificationsCubit, bool>(
                          builder: (context, isEnabled) => Switch(
                            value: isEnabled,
                            onChanged: (value) =>
                                context.read<NotificationsCubit>().toggle(value),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height / 40),

                _sectionLabel(context, 'VISUAL MODE'.tr(), labelPadding),
                const ProfileCard(
                  children: [
                    ThemeModeSelector(),
                    ThemeModeLabels(),
                  ],
                ),

                SizedBox(height: height / 30),

                ProfileCard(children: [
                  Tile(
                    icon: Icons.currency_exchange,
                    title: 'Currency'.tr(),
                    subtitle: context.watch<CurrencyCubit>().state.tr(),
                    onTap: () => _showCurrencySheet(context),
                  ),
                ]),

                SizedBox(height: height / 30),

                ProfileCard(children: [
                  Tile(
                    icon: Icons.call,
                    title: 'Contact Support'.tr(),
                    trailing: Icon(Icons.arrow_forward_ios, size: width / 24),
                    onTap: () async {
                      final whatsappUrl =
                      Uri.parse('https://wa.me/201159588434');
                      try {
                        await launchUrl(
                          whatsappUrl,
                          mode: LaunchMode.externalApplication,
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF1E1E1E),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(width / 30),
                              ),
                              content: Row(
                                children: [
                                  Icon(Icons.call,
                                      color: const Color(0xFFD4A843),
                                      size: width / 20),
                                  SizedBox(width: width / 40),
                                  Text(
                                    'whatsapp_not_installed'.tr(),
                                    style: TextStyle(
                                      color: const Color(0xFFD4A843),
                                      fontSize: width / 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ]),

                SizedBox(height: height / 20),
                const ProfileCard(children: [SignOutButton()]),
                SizedBox(height: height / 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label, double padding) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding, left: padding, right: padding),
      child: Text(
        label,
        style: context.body14?.copyWith(letterSpacing: 2),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      color: context.theme.dividerTheme.color,
      indent: context.screenWidth / 8,
    );
  }

  void _showCurrencySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.screenWidth / 16),
        ),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<CurrencyCubit>(),
        child: const CurrencySheet(),
      ),
    );
  }
}









class CurrencySheet extends StatelessWidget {
  const CurrencySheet({super.key});

  static const _currencies = [
    ('EGP', '🇪🇬'),
    ('USD', '🇺🇸'),
    ('EUR', '🇪🇺'),
    ('GBP', '🇬🇧'),
    ('SAR', '🇸🇦'),
    ('AED', '🇦🇪'),
  ];

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;
    final width = context.screenWidth;

    return Padding(
      padding: EdgeInsets.all(width / 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width / 10,
            height: height / 200,
            decoration: BoxDecoration(
              color: context.textHint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: height / 40),
          ..._currencies.map(
                (c) => _CurrencyOption(code: c.$1, flag: c.$2),
          ),
          SizedBox(height: height / 80),
        ],
      ),
    );
  }
}

class _CurrencyOption extends StatelessWidget {
  final String code;
  final String flag;

  const _CurrencyOption({required this.code, required this.flag});

  @override
  Widget build(BuildContext context) {

    final height = context.screenHeight;
    final width = context.screenWidth;
    final isSelected = context.watch<CurrencyCubit>().state == code;

    return GestureDetector(
      onTap: () async {
        await context.read<CurrencyCubit>().changeCurrency(code);
        if (context.mounted) Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: height / 120),
        padding: EdgeInsets.symmetric(
          horizontal: width / 24,
          vertical: height / 70,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary.withOpacity(0.1)
              : context.scaffoldBg,
          borderRadius: BorderRadius.circular(width / 30),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.textHint.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${'$code'.tr()} $flag', style: context.body16),
            if (isSelected)
              Icon(Icons.check, color: context.colorScheme.primary, size: width / 18),
          ],
        ),
      ),
    );
  }
}