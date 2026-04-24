import 'package:flutter/material.dart';

class Chipp extends StatelessWidget {
  final String label;
  final Color gold;

  const Chipp({required this.label, required this.gold});

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final height=size.height;
    final width=size.width;
    return Container(
      padding:  EdgeInsets.symmetric(
          horizontal: (width/30),////16
          vertical: (height/50)


      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: gold.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style:  TextStyle(color: Colors.white,
            fontSize: (height / 50).clamp(13, 24)

        ),
      ),
    );
  }
}
