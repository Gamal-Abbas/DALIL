import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/theme_extension.dart';

class Stateitem extends StatelessWidget {
  final String label;
  final String value;
  final Color gold;

  const Stateitem({
    super.key,
    required this.label,
    required this.value,
    required this.gold,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.primary.withOpacity(0.5),
            fontSize: (height / 45).clamp(15, 40), //14
            letterSpacing: (width / 326).clamp(1.2, 4.8), //1.2
          ),
        ),
        Gap((height / 200).clamp(4, 6)),
        Text(
          value,
          style: TextStyle(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: (height / 50).clamp(14, 35), //14
          ),
        ),
      ],
    );
  }
}
