
import 'package:depi_dalil/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/size.dart';
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
            SizedBox(height: context.screenHeight / 16),

                _buildBackButton(context),
                Gap(context.screenHeight * 0.45),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.screenWidth / 16),
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
