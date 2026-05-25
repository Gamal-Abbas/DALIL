class FormatYear {
  final dynamic year;

  FormatYear({required this.year});

  static String formatYear(String year) {
    if (year == null || year.toString().isEmpty) return "??";
    String yStr = year.toString();
    if (yStr.contains('-')) {
      // return "${yStr.replaceAll('-', '')} ق.م";
      return "${yStr.replaceAll('-', '')} B.C";
    }
    // return "$yStr م";
    return "$yStr C";
  }
}
