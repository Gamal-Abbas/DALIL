import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/customWidgets/customText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class welcomeSection extends StatelessWidget {
  const welcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final SH = size.height;
    return Column(
      spacing: context.screenHeight / 400,
      children: [
        Customtext(
          weight: FontWeight.w400,
          text: 'slogan'.tr(),
          size: (context.screenHeight / 65).clamp(12, 48),
          color: AppColors.thirdDark,
        ),
        Customtext(
          weight: FontWeight.w800,
          text: 'welcomeBack'.tr(),
          size: (context.screenHeight / 33.5).clamp(24, 96),
          color: AppColors.third,
        ),
      ],
    );
  }
}
