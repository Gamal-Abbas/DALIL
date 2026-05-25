
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/utils/formatYear.dart';
import '../../data/models/eraModel.dart';
import '../widgets/sectionTitle.dart';
import 'baseLayout.dart';

class EraUI extends StatelessWidget {
  final double height;
  final double width;

  final EraModel data;

  const EraUI({
    super.key,
    required this.data,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double titleSize = (height / 20).clamp(40, 60);
    final double sectionHeaderSize = (height / 40).clamp(20, 35);
    final double bodySize = (height / 47).clamp(17, 34);
    final double bodyLineHeight = (height / 470).clamp(1.7, 2);
    final double letterSpacing = (width / 780).clamp(0.5, 2.3);
    final double ColumnSpacing = (height / 40).clamp(20, 23);
    print('era UI ==========');
    print(data.id);
    print("Debug Data: ${data.toJson()}");
    print(data.endYear);

    return BaseLayout(
      title: data.name,
      image: data.image,
      child: Column(
        spacing: ColumnSpacing, //20
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle("historical_eras".tr()),

          Text(
            data.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize, //42
              height: (height / 730).clamp(1.1, 1.5), //1.1
              fontWeight: FontWeight.w900,
            ),
          ),

          if (data.startYear != null || data.endYear != null)
            _buildTimelineBadge(
              data.startYear,
              data.endYear,AppColors.secondary,
              height,
            ),

          // الوصف النصي مباشرة
          Text(
            "about_this_era".tr(),
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: sectionHeaderSize, //20
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            data.description,
            style: TextStyle(
              color: AppColors.white_with_opacity_09,
              fontSize: bodySize, //17
              height: bodyLineHeight, //1.7
              letterSpacing: letterSpacing,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineBadge(int? start, int? end, Color gold, double height) {
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
            "${FormatYear.formatYear(start.toString()) ?? '...'}  ${FormatYear.formatYear(end.toString()) ?? '...'}",
            style: TextStyle(
              color: Colors.white,
              fontSize: (height / 47).clamp(17, 34), //17
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
