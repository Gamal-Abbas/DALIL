
import 'package:depi_dalil/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../widgets/buidGredientOverlay.dart';
import '../widgets/buildHeroImage.dart';

class BaseLayout extends StatelessWidget {
  final String title;
  final String image;
  final Widget child;

  const BaseLayout({
    super.key,
    required this.title,
    required this.image,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: Stack(
        children: [
          Buildheroimage(url: image),
          Buidgredientoverlay(),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                _buildBackButton(context),
                Gap(MediaQuery.of(context).size.height * 0.45),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [child],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: IconButton(
      onPressed: () => Navigator.pop(context),
      icon:  Icon(Icons.arrow_back_ios_new, color: context.iconColor, size: 18),
      style: IconButton.styleFrom(
        backgroundColor: context.scaffoldBg,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
  );
}
