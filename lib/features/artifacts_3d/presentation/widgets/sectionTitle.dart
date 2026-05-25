import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;

    return Text(
      title,
      style: TextStyle(
        color: context.colorScheme.primary,
        fontSize: (height / 40).clamp(18, 36), //18
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
