import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/customWidgets/customText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class SignUpHeader extends StatelessWidget {

  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Customtext(
          weight: FontWeight.w400,
          text: 'slogan'.tr(),
          size: (context.screenHeight / 65).clamp(12, 48),
          color: AppColors.thirdDark,
        ),
        Customtext(
          weight: FontWeight.w800,
          text: 'createAccount'.tr(),
          size: (context.screenHeight / 33.5).clamp(24, 96),
          color: AppColors.third,
        ),
      ],
    );
  }
}