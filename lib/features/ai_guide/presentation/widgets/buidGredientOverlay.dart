import 'package:flutter/material.dart';

class Buidgredientoverlay extends StatelessWidget {
  const Buidgredientoverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.9, 1.0],
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
              Colors.black.withOpacity(0.8),
              Colors.black,
            ],
          ),
        ),
      ),
    );
  }
}
