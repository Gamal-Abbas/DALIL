import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Customtext extends StatelessWidget {
  final FontWeight weight;
  final String text;
  final double size;
  final Color color;

  const Customtext({
    super.key,
    required this.weight,
    required this.text,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: weight,
        fontSize: size,
        color: color,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
