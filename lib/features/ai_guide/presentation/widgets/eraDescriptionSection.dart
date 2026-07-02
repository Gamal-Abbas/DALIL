import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/utils/size.dart';

class EraDescriptionSection extends StatelessWidget {
  final String description;
  final String name;
  final Color gold;
  final double fontSizeTitle;
  final double fontSizeBody;
  final double gapHeight;

  const EraDescriptionSection({
    super.key,
    required this.description,
    required this.name,
    required this.gold,
    required this.fontSizeTitle,
    required this.fontSizeBody,
    required this.gapHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "about_this_era".tr(),
          style: TextStyle(
            fontSize: fontSizeTitle, //18
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          name,
          style: TextStyle(
            fontSize: fontSizeBody, //18
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),

        Gap(gapHeight), //12

        Text(
          description ?? "",
          style: TextStyle(
            // color: Colors.white.withOpacity(0.6),
            color: AppColors.white_with_opacity_06,
            fontSize: fontSizeBody, //14
            height: (context.screenHeight / 530).clamp(1.5, 2), //1.5
          ),
        ),

        Gap(gapHeight),
      ],
    );
  }
}
