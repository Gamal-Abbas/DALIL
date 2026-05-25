import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';

class Signmethode extends StatelessWidget {
  final Function() googleontap;
  final Function() facebookontap;
  final Function() appleontap;

  const Signmethode({
    super.key,
    required this.googleontap,
    required this.facebookontap,
    required this.appleontap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: googleontap,
          child: SvgPicture.asset(
            'assets/logo/google.svg',
            height: context.screenHeight / 13.4,
            width: context.screenWidth / 6.5,
          ),
        ),
        GestureDetector(
          onTap: facebookontap,
          child: SvgPicture.asset(
            'assets/logo/facebook.svg',
            height: context.screenHeight / 13.4,
            width: context.screenWidth / 6.5,
          ),
        ),

      ],
    );
  }
}