import 'dart:core';

import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extension.dart';

class Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  String? subtitle;
  Widget? trailing;
  VoidCallback? onTap;
  Tile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.body18),
                  if (subtitle != null) Text(subtitle!, style: context.body14),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
