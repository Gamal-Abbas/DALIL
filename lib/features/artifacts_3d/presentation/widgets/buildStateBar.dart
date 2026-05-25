
import 'package:depi_dalil/features/artifacts_3d/presentation/widgets/stateItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/formatYear.dart';
import '../../data/models/eraModel.dart';

class BuildStateBar extends StatelessWidget {
  final EraModel eraInfo;
  final Color gold;

  const BuildStateBar({super.key, required this.eraInfo, required this.gold});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Row(
      children: [
        Stateitem(
          label: "liveBetween".tr(),
          gold: gold,
          value:
              "${FormatYear.formatYear(eraInfo.startYear.toString() ?? '??')} - ${FormatYear.formatYear(eraInfo.endYear.toString() ?? '??')}",
        ),
        Gap((height / 20).clamp(40, 80)),
        Stateitem(label: "location".tr(), value: "EGYPT / BANHA", gold: gold),
      ],
    );
  }
}
