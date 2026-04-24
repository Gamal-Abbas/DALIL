import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_color.dart';

class Signmethode extends StatelessWidget {
  final Function() googleontap;
  final Function() facebookontap;
  final Function() appleontap;
  const Signmethode({super.key,
    required this.googleontap,
    required this.facebookontap,
    required this.appleontap,
    });

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final SH=size.height;
    final SW=size.width;
    // print(SH);
    // print(SW);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: googleontap,
          child: SvgPicture.asset(
            'assets/logo/google.svg',
            height: SH/13.4,//60
            width: SW/6.5,//60
          ),
        ),
        GestureDetector(
          onTap: facebookontap,
          child: SvgPicture.asset(
            'assets/logo/facebook.svg',
            height: SH/13.4,//60
            width: SW/6.5,//60
          ),
        ),
        GestureDetector(
          onTap: appleontap,
          child: SvgPicture.asset(
            'assets/logo/apple.svg',
            color: AppColors.third,
            height: SH/13.4,//60
            width: SW/6.5,//60
          ),
        ),
      ],
    );
  }
}
