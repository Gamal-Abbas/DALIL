import 'dart:io';
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
    final width = context.screenWidth;
    final height = context.screenHeight;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final imagePath = state is ProfileLoaded ? state.imagePath : null;
        final name = state is ProfileLoaded ? state.user.name : null;

        return Column(
          spacing: height / 40,
          children: [
            GestureDetector(
              onTap: () => context.read<ProfileCubit>().pickImage(),
              child: Stack(
                children: [
                  Container(
                    width: width / 3,
                    height: width / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width / 20),
                      border: Border.all(
                        color: context.colorScheme.primary,
                        width: height / 400,
                      ),
                      color: context.cardColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(width / 20),
                      child: imagePath != null
                          ? Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        width: width / 3,
                        height: width / 3,
                      )
                          : Icon(
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
                      onTap: () => context.read<ProfileCubit>().pickImage(),
                      child: Container(
                        padding: EdgeInsets.all(width / 30),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary,
                          borderRadius: BorderRadius.circular(width / 30),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: width / 25,
                          color: context.scaffoldBg,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            name != null
                ? Text(
              name,
              style: context.headline40?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            )
                : CircularProgressIndicator(),
          ],
        );
      },
    );
  }
}