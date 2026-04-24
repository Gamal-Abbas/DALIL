import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;

    return Text(
      title,
      style:  TextStyle(
        color: Colors.amber,
        fontSize: (height/40).clamp(18, 36),  //18
        fontWeight: FontWeight.bold,
      ),
    );
  }
}