import 'package:flutter/material.dart';

class Buildheroimage extends StatelessWidget {
  final String url;
  const Buildheroimage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Container(color: Colors.black),
      ),
    );
  }
}
