import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/utils/size.dart';

class ScanInstruction extends StatelessWidget {
  const ScanInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    final double fontSize = (context.screenHeight / 40).clamp(16, 48);

    return Text(
      "scan_instruction".tr(),
      style: TextStyle(
        color: AppColors.secondary,
        fontSize: fontSize,

        ///18
        fontWeight: FontWeight.bold,
        shadows: [Shadow(blurRadius: 15, color: Colors.black)],
      ),
    );
  }
}
