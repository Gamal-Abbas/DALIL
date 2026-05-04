import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/customWidgets/customText.dart';
import 'package:dalil/features/Auth/login/views/loginView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Haveaccountsection extends StatelessWidget {
  const Haveaccountsection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Customtext(
          text: 'haveAcount'.tr(),
          size: (context.screenHeight / 40).clamp(14, 35),
          color: AppColors.thirdDark,
          weight: FontWeight.w400,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => Loginview()),
            );
          },
          child: Customtext(
            text: 'login'.tr(),
            size: (context.screenHeight / 50).clamp(15, 35),
            color: AppColors.secondary,
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
