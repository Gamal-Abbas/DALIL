import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../../customWidgets/customText.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.screenHeight / 400,
      children: [
        Customtext(
          weight: FontWeight.w400,
          text: 'slogan'.tr(),
          size: (context.screenHeight / 65).clamp(12, 48),
          color: context.textHint,
        ),
        Customtext(
          weight: FontWeight.w800,
          text: 'welcomeBack'.tr(),
          size: (context.screenHeight / 33.5).clamp(24, 96),
          color: context.textSecondary,
        ),
      ],
    );
  }
}