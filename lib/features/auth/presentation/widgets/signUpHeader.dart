import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../../customWidgets/customText.dart';

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
          color: context.textHint,
        ),
        Customtext(
          weight: FontWeight.w800,
          text: 'createAccount'.tr(),
          size: (context.screenHeight / 33.5).clamp(24, 96),
          color: context.textSecondary,
        ),
      ],
    );
  }
}