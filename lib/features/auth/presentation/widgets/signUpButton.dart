import 'package:flutter/cupertino.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../../customWidgets/customButton.dart';

class SignUpButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const SignUpButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return customButton(
      text: label,
      onPressed: onPressed,
      textSize: (context.screenHeight / 40.25).clamp(20, 80),
      buttonWeight: (context.screenWidth / 1.41).clamp(278, 1300),
      buttonHeight: (context.screenHeight / 14.37).clamp(56, 60),
      fontWeight: FontWeight.w700,
      buttonColor: context.colorScheme.primary,
      textColor: context.scaffoldBg,
    );
  }
}