import 'package:dalil/features/ArtifactDetails/widgets/buidGredientOverlay.dart';
import 'package:dalil/features/ArtifactDetails/widgets/buildHeroImage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
    const Color pharaohGold = Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: Colors.black,
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
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black38,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
  );
}
