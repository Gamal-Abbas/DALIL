import 'dart:ui';
import 'package:dalil/features/ArtifactDetails/view/chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    print('Related =======================');
    print(widget.related);
    final era = widget.eraInfo;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== DESCRIPTION =====
              Text(
                "historical_eras".tr(),
                style: TextStyle(
                 fontSize: (height/50).clamp(16, 22),   //14
                  color: widget.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap((height/55).clamp(12, 24)),  ///15

              Text(
                widget.description.isEmpty
                    ? "no_description_available".tr()
                    : widget.description,
                maxLines: showFull ? null : 4,
                overflow: showFull ? null : TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: (height / 44).clamp(16, 32), //16
                  height: (height / 520).clamp(1.6, 2), //1.6
                ),
              ),

              if (widget.description.length > 150)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showFull = !showFull;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: height / 100).clamp(
                      EdgeInsetsGeometry.symmetric(vertical: 8),
                      EdgeInsetsGeometry.symmetric(vertical: 12),
                    ),
                    child: Text(
                      showFull ? "seeMore".tr() : "seeLess".tr(),
                      style: TextStyle(
                        fontSize: (height/55).clamp(14, 20),   //14
                        color: widget.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

               Divider(color: Colors.white12,
                   height: (height/20).clamp(40, 60)   //40


               ),

              // ===== ERA =====
              if (era != null && (era.name ?? "").isNotEmpty) ...[
                Text(

                  "about_this_era".tr(),
                  style: TextStyle(
                    fontSize: (height/45).clamp(18, 36),     //18
                    color: widget.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),


                Text(

                  "${era.name}",
                  style: TextStyle(
                    fontSize: (height/45).clamp(18, 36),     //18
                    color: widget.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Gap((height/55).clamp(12, 20)) ,        //12

                Text(
                  era.description ?? "",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: (height / 44).clamp(16, 32),       //14
                    height: (height/530).clamp(1.5, 2),             //1.5
                  ),
                ),

               Gap((height/50).clamp(15, 20)),///////15
                 Divider(color: Colors.white12,
                    height: (height/20).clamp(40, 50)   //40
                ),
              ],

              // ===== RELATED =====
              if (widget.related.isNotEmpty) ...[
                Text(
                  "related".tr(),
                  style: TextStyle(
                    fontSize: (height / 50).clamp(16, 28),
                    color: widget.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Gap((height/50).clamp(15, 20)),  ///15

                Wrap(
                  spacing: (width/49).clamp(8, 32),      //8
                  runSpacing: (width/49).clamp(8, 32),       //8
                  children: widget.related
                      .map((e) => Chipp(label: e.toString(), gold: widget.gold))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
