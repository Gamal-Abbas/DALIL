import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalil/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppDialogs {

  static void showCustomDialog(BuildContext context, {

    required String title,
    required String desc,
    required IconData icon,
    required Color iconColor,
    VoidCallback? btnOkOnPress,
  }) {
    final size=MediaQuery.of(context).size;
    final SH=size.height;
    final SW=size.width;
    AwesomeDialog(

      context: context,
      animType: AnimType.rightSlide,
      dialogBackgroundColor: AppColors.primary,
      keyboardAware: true,
      headerAnimationLoop: false,
      customHeader: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: SH/10,//80
          color: iconColor,
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: SH/40.25,
            horizontal: SW/39.2),//20  10
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: SH/36.5,//22
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            Gap(SH/80),//10
            Text(
              desc,
              textAlign: TextAlign.center,
              style:  TextStyle(
                fontSize: SH/50,//16
                color: AppColors.thirdDark,
              ),
            ),
          ],
        ),
      ),
      btnOkColor: AppColors.secondary,
      btnOkOnPress: btnOkOnPress ?? () {},
    ).show();
  }
}