import 'package:flutter/material.dart';

import '../core/constants/app_color.dart';

class customButton extends StatelessWidget {
  final String text;
  final double textSize;
  final FontWeight fontWeight;
  final double buttonWeight;
  final double buttonHeight;
  final Color buttonColor;
  final Color textColor;

  final VoidCallback onPressed;
  final double width;

  const customButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    required this.textSize,
    required this.fontWeight,
    required this.buttonWeight,
    required this.buttonHeight,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
  final SH=size.height;
  final SW=size.width;

    return SizedBox(
      width: buttonWeight,
      height: buttonHeight,
      child: ElevatedButton(

        style: ElevatedButton.styleFrom(

          backgroundColor: buttonColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 9,
          shadowColor: AppColors.secondary,

        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: fontWeight,
            letterSpacing: (SW/350).clamp(1.1, 4.4),//1.1
          ),
        ),
      ),
    );
  }
}
