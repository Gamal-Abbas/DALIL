import 'package:flutter/cupertino.dart';

import '../../../../core/theme/theme_extension.dart';

class ProfileCard extends StatelessWidget {
  final List<Widget>children;
  const ProfileCard({super.key,  required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}
