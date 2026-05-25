import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../../customWidgets/customText.dart';
import '../pages/signUpView.dart';

class noAccountSection extends StatelessWidget {
  const noAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Customtext(
          text: 'noAccount'.tr(),
          size: (context.screenHeight / 40).clamp(14, 35),
          color: context.textHint,
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
            color: context.primary,
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}