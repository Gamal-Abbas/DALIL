import 'package:flutter/material.dart';
import 'package:dalil/generated/l10n.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        children: [
          Text(
            loc.welcome,
            style: TextStyle(color: Colors.white70, fontSize: width * 0.04),
          ),
          SizedBox(height: width * 0.02),
          Text(
            loc.historyAwaits,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFE5C158),
              fontSize: width * 0.07,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: width * 0.03),
          Text(
            loc.homeDesc,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: width * 0.035),
          ),
        ],
      ),
    );
  }
}