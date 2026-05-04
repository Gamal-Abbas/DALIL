import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/customWidgets/customText.dart';
import 'package:dalil/features/Auth/register/views/signUpView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class noAccountSection extends StatelessWidget {
  const noAccountSection({super.key});

  @override
  Widget build(BuildContext context) {

    // final SH = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Customtext(
          text: 'noAccount'.tr(),
          size: (context.screenHeight / 40).clamp(14, 35),
          color: AppColors.thirdDark,
          weight: FontWeight.w400,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => SignupView()),
            );
          },
          child: Customtext(
            text: 'signUp'.tr(),
            size: (context.screenHeight / 50).clamp(15, 35),
            color: AppColors.secondary,
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
