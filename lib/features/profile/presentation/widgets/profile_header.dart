import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:depi_dalil/core/utils/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_extension.dart';
import '../manager/profile_cubit.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width=context.screenWidth;
    final height=context.screenHeight;
    return Column(
      spacing: height / 40,
      children: [
        GestureDetector(
          onTap: () {},
          child: Stack(
            children: [
              Container(
                width: width / 3,
                height: width / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width/20),
                  border: Border.all(
                    color: context.colorScheme.primary,
                    width: height/400,
                  ),
                  color: context.cardColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Icon(
                    Icons.person,
                    size: width / 5,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: width/25,
                      color: context.scaffoldBg,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),



        // ── Name ──
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context,state){
            return state is ProfileLoaded?
             Text(
               state.user.name,
              style: context.headline40?.copyWith(fontWeight: FontWeight.w900),
            ):CircularProgressIndicator();
          },

        ),



        // ── Role ──
        Text(
          'CHIEF CURATOR',
          style: context.body14?.copyWith(
            color: context.colorScheme.primary,
            letterSpacing: 3,

          ),
        ),
      ],
    );
  }
}
