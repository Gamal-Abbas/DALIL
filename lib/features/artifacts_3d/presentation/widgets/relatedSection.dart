import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../pages/chip.dart';

class RelatedSection extends StatelessWidget {
  final Color gold;
  final double fontSizeTitle;
  final double fontSizeBody;
  final double gapHeight;
  final double width;
  final List related;

  const RelatedSection({
    required this.gold,
    required this.fontSizeTitle,
    required this.fontSizeBody,

    required this.gapHeight,
    required this.width,
    required this.related,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "related".tr(),
          style: TextStyle(
            fontSize: fontSizeTitle,
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),

        Gap(gapHeight),

        ///15
        Wrap(
          spacing: (width / 49).clamp(8, 32), //8
          runSpacing: (width / 49).clamp(8, 32), //8
          children: related
              .map((e) => Chipp(label: e.toString(), gold: gold))
              .toList(),
        ),
      ],
    );
  }
}
