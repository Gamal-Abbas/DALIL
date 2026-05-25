import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:depi_dalil/features/profile/presentation/widgets/profile_header.dart';
import 'package:depi_dalil/features/profile/presentation/widgets/visualize_mode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../data/models/user_model.dart';
import '../manager/profile_cubit.dart';
import '../widgets/card.dart';
import '../widgets/profile_dialoge.dart';
import '../widgets/tile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileBody();
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
            return  _BodyContent(user: state.user);
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

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: height / 10),
          const ProfileHeader(),

          SizedBox(height: height / 20),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 18),
            child: Column(
              children: [
                _sectionLabel(context, 'ACCOUNT PREFERENCES'),
                ProfileCard(
                  children: [
                    Tile(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      onTap: () => ProfileDialog.showEditNameDialog(
                        context: context,
                        currentName: user.name,
                      ),
                    ),
                    _divider(context),
                    Tile(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: context.locale.languageCode == 'ar'
                          ? 'العربية'
                          : 'English (US)',
                      onTap: () =>
                          ProfileDialog.showLanguageSheet(context: context),
                    ),
                  ],
                ),

                SizedBox(height: height / 40),

                _sectionLabel(context, 'SECURITY & PRIVACY'),
                ProfileCard(
                  children: [
                    Tile(
                      icon: Icons.shield_outlined,
                      title: 'Two-Factor Authentication',
                      onTap: () {},
                    ),
                    _divider(context),
                    Tile(
                      icon: Icons.lock_outline,
                      title: 'Change Encryption Keys',
                      onTap: () {},
                    ),
                  ],
                ),

                SizedBox(height: height / 40),

                ProfileCard(
                  children: [
                    Tile(
                      icon: Icons.notifications_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Enable critical artifact updates',
                      trailing: RepaintBoundary(
                        child: Switch(value: true, onChanged: (_) {}),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height / 40),

                _sectionLabel(context, 'VISUAL MODE'),
                ProfileCard(
                  children: [const VisualMode(), const VisualModeLabels()],
                ),
                SizedBox(height: height / 20),
                ProfileCard(children: [const LogOutButton()]),
                SizedBox(height: height / 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label, style: context.body14?.copyWith(letterSpacing: 2)),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      color: context.textHint.withOpacity(0.1),
      indent: 52,
    );
  }
}
