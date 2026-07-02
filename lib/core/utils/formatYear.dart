import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class FormatYear {
  static String formatYear(String year, [BuildContext? context]) {
    if (year.isEmpty) return "??";

    final bc = context != null ? 'bC'.tr() : 'B.C';
    final ad = context != null ? 'c'.tr() : 'C';

    String yStr = year.toString();

    if (yStr.contains('-')) {
      final number = yStr.replaceAll('-', '');
      return "$number $bc";
    }

    return "$yStr $ad";
  }

  static String formatRange(String from, String to, [BuildContext? context]) {
    final fromNum = int.tryParse(from) ?? 0;
    final toNum = int.tryParse(to) ?? 0;

    final older = fromNum < toNum ? from : to;
    final newer = fromNum < toNum ? to : from;

    return "${formatYear(older, context)} - ${formatYear(newer, context)}";
  }
}