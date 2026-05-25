import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';

class AppDialogs {
  static void showCustomDialog(
      BuildContext context, {
        required String title,
        required String desc,
        required IconData icon,
        required Color iconColor,
        VoidCallback? btnOkOnPress,
      }) {
    AwesomeDialog(
      context: context,
      animType: AnimType.rightSlide,
      dialogBackgroundColor: context.scaffoldBg,
      keyboardAware: true,
      headerAnimationLoop: false,
      customHeader: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: context.screenHeight / 10,
          color: iconColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.screenHeight / 40.25,
          horizontal: context.screenWidth / 39.2,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: context.screenHeight / 36.5,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
              ),
            ),
            Gap(context.screenHeight / 80),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.screenHeight / 50,
                color: context.textHint,
              ),
            ),
          ],
        ),
      ),
      btnOkColor: context.colorScheme.primary,
      btnOkOnPress: btnOkOnPress ?? () {},
    ).show();
  }
}