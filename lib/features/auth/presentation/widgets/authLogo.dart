import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';

class authLogo extends StatelessWidget {
  const authLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'dalil'.tr(),
      style: TextStyle(
        letterSpacing: (context.screenWidth / 78).clamp(5, 20),
        fontWeight: FontWeight.bold,
        fontSize: (context.screenHeight / 13).clamp(52, 104),
        color: context.primary,
        fontStyle: FontStyle.italic,
        shadows: [
          Shadow(
            color: context.primary,
            blurRadius: 12,
            offset: const Offset(4, 4),
          ),
        ],
      ),
    );
  }
}