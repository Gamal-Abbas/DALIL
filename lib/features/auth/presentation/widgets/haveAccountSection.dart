
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/utils/size.dart';
import '../../../../customWidgets/customText.dart';
import '../pages/loginView.dart';

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
