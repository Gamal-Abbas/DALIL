import 'dart:ui';

import 'package:depi_dalil/features/ai_guide/presentation/widgets/relatedSection.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import 'descriptionSection.dart';
import 'eraDescriptionSection.dart';

class MainContentCard extends StatefulWidget {
  final String description;
  final dynamic eraInfo;
  final List related;
  final Color gold;

  const MainContentCard({
    super.key,
    required this.description,
    required this.eraInfo,
    required this.related,
    required this.gold,
  });

  @override
  State<MainContentCard> createState() => _MainContentCardState();
}

class _MainContentCardState extends State<MainContentCard> {
  bool showFull = false;

  late double height;
  late double width;
  late double height_divise_45;
  late double height_divise_20;

  late double height_divise_55;

  late double height_divise_50;

  late double width_divise_50;

  @override
  void didChangeDependencies() {
    // build one time only
    print('didChangeDependencies =======================');
    super.didChangeDependencies();


    height = context.screenHeight;
    width = context.screenWidth;
    height_divise_45 = (height / 45).clamp(18, 36);
    height_divise_20 = (height / 20).clamp(40, 60);
    height_divise_55 = (height / 55).clamp(12, 24);
    height_divise_50 = (height / 50).clamp(16, 22);
    width_divise_50 = (height / 50).clamp(16, 22);
  }

  @override
  Widget build(BuildContext context) {
    print('build    mainContainer  =======================');
    print(widget.related);
    final era = widget.eraInfo;

    return RepaintBoundary(
      /// to reduce rebuild
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.secondary.withOpacity(0.08),
              // color: AppColors.white_with_opacity_008,

              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DescriptionSection(
                  description: widget.description,
                  showFull: showFull,
                  onToggle: () {
                    // setState(() {
                    //   showFull = !showFull;
                    // });
                  },
                  gold: context.primary,
                  fontSizeTitle: height_divise_50,
                  fontSizeBody: height_divise_45,
                  fontSizeSeeMore: height_divise_55,
                  gapHeight: height_divise_55,
                  height: height,
                ),
                Divider(
                  color: Colors.white12,
                  height: height_divise_20, //40
                ),

                // ===== ERA =====
                if (era != null && (era.name ?? "").isNotEmpty) ...[
                  EraDescriptionSection(
                    description: era.description,
                    name: era.name,
                    gold: context.primary,
                    fontSizeTitle: height_divise_45,
                    fontSizeBody: height_divise_55,
                    gapHeight: height_divise_55,
                  ),
                  Divider(
                    color: Colors.white12,
                    height: height_divise_20, //40
                  ),
                ],

                // ===== RELATED =====
                if (widget.related.isNotEmpty) ...[
                  RelatedSection(
                    gold: context.colorScheme.primary,
                    fontSizeTitle: height_divise_55,
                    fontSizeBody: height_divise_45,

                    gapHeight: height_divise_55,
                    width: width,
                    related: widget.related,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
