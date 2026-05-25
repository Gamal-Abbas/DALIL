import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../../customWidgets/customButton.dart';

class Loginbutton extends StatelessWidget {
  final VoidCallback onPressed;

  const Loginbutton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return customButton(
      text: 'login'.tr(),
      onPressed: onPressed,
      fontWeight: FontWeight.w700,
      textSize: (context.screenHeight / 40.25).clamp(20, 80),
      buttonWeight: (context.screenWidth / 1.41).clamp(278, 1300),
      buttonHeight: (context.screenHeight / 14.37).clamp(56, 60),
      buttonColor: context.colorScheme.primary,
      textColor: context.scaffoldBg,
    );
  }
}