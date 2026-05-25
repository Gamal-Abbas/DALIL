import 'package:depi_dalil/features/qr_code/presentation/widgets/pharaonCorner.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/constants/app_color.dart';

class Sides extends StatelessWidget {
  const Sides({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: buildPharaohCorner(
            top: true,
            left: true,
            color: AppColors.secondary,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: buildPharaohCorner(
            top: true,
            left: false,
            color: AppColors.secondary,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: buildPharaohCorner(
            top: false,
            left: true,
            color: AppColors.secondary,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: buildPharaohCorner(
            top: false,
            left: false,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
