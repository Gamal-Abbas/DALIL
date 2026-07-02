import 'package:flutter/material.dart';

import '../../../../core/constants/app_color.dart';

class Chipp extends StatelessWidget {
  final String label;
  final Color gold;

  const Chipp({required this.label, required this.gold});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (width / 30), ////16
        vertical: (height / 50),
      ),
      decoration: BoxDecoration(
        color: AppColors.white_with_opacity_005,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.gold_with_opacity_03),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: (height / 50).clamp(13, 24),
        ),
      ),
    );
  }
}
