import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class authLogo extends StatelessWidget {

  // final  double SH; final double SW;
  const authLogo({super.key,
    // required this.SH, required this.SW
  });

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final SH = size.height;
    // final SW = size.width;
    return Text(
      'dalil'.tr(),
      style: TextStyle(
        letterSpacing: (context.screenWidth / 78).clamp(5, 20),
        fontWeight: FontWeight.bold,
        fontSize: (context.screenHeight / 13).clamp(52, 104),
        color: AppColors.secondary,
        fontStyle: FontStyle.italic,
        shadows: [
          const Shadow(
            color: AppColors.secondaryLight,
            blurRadius: 12,
            offset:  Offset(4, 4),
          ),
        ],
      ),
    );
  }
}
