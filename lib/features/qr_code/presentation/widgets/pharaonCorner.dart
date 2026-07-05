import 'package:flutter/cupertino.dart';

import '../../../../core/utils/size.dart';

class buildPharaohCorner extends StatelessWidget {
  final bool top;
  final bool left;
  final Color color;

  const buildPharaohCorner({
    super.key,
    required this.top,
    required this.left,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double cornerSize = (context.screenHeight / 18).clamp(40, 60);

    ///40
    double cornerThickness = (context.screenHeight / 160).clamp(5, 20);

    ///5
    return Container(
      width: cornerSize,
      height: cornerSize,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? BorderSide(color: color, width: cornerThickness)
              : BorderSide.none,
          bottom: !top
              ? BorderSide(color: color, width: cornerThickness)
              : BorderSide.none,
          left: left
              ? BorderSide(color: color, width: cornerThickness)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: color, width: cornerThickness)
              : BorderSide.none,
        ),
      ),
    );
  }
}
