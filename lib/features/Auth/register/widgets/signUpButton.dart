import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/customWidgets/customButton.dart';
import 'package:flutter/cupertino.dart';

class Signupbutton extends StatelessWidget {
  final VoidCallback onPressed;
final String label;
  const Signupbutton({super.key, required this.onPressed, required this.label,

  });

  @override
  Widget build(BuildContext context) {
    return customButton(
      text:label,
      onPressed: onPressed,
      textSize: (context.screenHeight / 40.25).clamp(20, 80),
      buttonWeight: (context.screenWidth / 1.41).clamp(278, 1300),
      buttonHeight: (context.screenHeight / 14.37).clamp(56, 60),
      fontWeight: FontWeight.w700,
      buttonColor: AppColors.secondary,
      textColor: AppColors.primary,
    );
  }
}
