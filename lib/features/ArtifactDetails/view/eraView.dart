import 'package:dalil/features/ArtifactDetails/data/class/formatYear.dart';
import 'package:dalil/features/ArtifactDetails/data/model/eraModel.dart';
import 'package:dalil/features/ArtifactDetails/view/baseLayout.dart';
import 'package:dalil/features/ArtifactDetails/widgets/sectionTitle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EraUI extends StatelessWidget {
  final EraModel data;

  const EraUI({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    print('era UI ==========');
    print(data.id);
    print("Debug Data: ${data.toJson()}");
    print(data.endYear);
    const Color pharaohGold = Color(0xFFFFD700);
    final size=MediaQuery.of(context).size;
    final height=size.height;
    final width=size.width;
    return BaseLayout(
      title: data.name,
      image: data.image,
      child: Column(
        spacing: (height/40).clamp(20, 23),     //20
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           SectionTitle("historical_eras".tr(),

          ),



          Text(
            data.name,
            style:  TextStyle(
              color: Colors.white,
              fontSize: (height/20).clamp(40, 60),    //42
              height: (height/730).clamp(1.1, 1.5),      //1.1
              fontWeight: FontWeight.w900,
            ),
          ),




          if (data.startYear != null || data.endYear != null)
            _buildTimelineBadge(data.startYear, data.endYear, pharaohGold,height),



          // الوصف النصي مباشرة
           Text(
            "about_this_era".tr(),
            style: TextStyle(
              color: pharaohGold,
              fontSize: (height/40).clamp(20, 35),    //20
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            data.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: (height/47).clamp(17, 34),    //17
              height: (height/470).clamp(1.7, 2),      //1.7
              letterSpacing: (width/780).clamp(0.5, 2.3),
            ),
          ),


        ],
      ),
    );
  }


  Widget _buildTimelineBadge(int? start, int? end, Color gold,double height) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: gold.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history_toggle_off, color: Colors.amber, size: 20),
          const Gap(10),
          Text(
            "${ FormatYear.formatYear(start.toString())?? '...'}  ${FormatYear.formatYear(end.toString()) ?? '...'}",
            style:  TextStyle(
              color: Colors.white,
              fontSize: (height/47).clamp(17, 34),    //17
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}