import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';

class Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const Tile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width / 24,
          vertical: height / 70,
        ),
        child: Row(
          children: [
            Icon(icon, size: width / 16),
            SizedBox(width: width / 28),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.body18),
                  if (subtitle != null)
                    Text(subtitle!, style: context.body14),
                ],
              ),
            ),
            trailing ?? Icon(Icons.arrow_forward_ios, size: width / 24),
          ],
        ),
      ),
    );
  }
}