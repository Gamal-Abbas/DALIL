import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/customWidgets/customButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class Loginbutton extends StatelessWidget {
  final VoidCallback onPressed;
  const Loginbutton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {

    return customButton(
      text: 'login'.tr(),
      // onPressed: () async {
      //   // onLogin(context: context);
      // },
      onPressed: onPressed,
      fontWeight: FontWeight.w700,
      textSize: (context.screenHeight / 40.25).clamp(20, 80),
      buttonWeight: (context.screenWidth / 1.41).clamp(278, 1300),
      buttonHeight: (context.screenHeight / 14.37).clamp(56, 60),
      buttonColor: AppColors.secondary,
      textColor: AppColors.primary,
    );
  }
}
