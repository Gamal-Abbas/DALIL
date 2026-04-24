import 'package:shared_preferences/shared_preferences.dart';

class cash {
  static late SharedPreferences pref;
  static Future<void> initialpref() async {
    pref = await SharedPreferences.getInstance();
  }



  static Future<bool> setLang(String langCode) async {
    return await pref.setString('language', langCode);
  }

  static String getLang() {
    String? lang = pref.getString('language');
    return (lang == null || lang.isEmpty) ? 'ar' : lang;
  }



  static Future<bool> insertIntoCash({
    required String key,
    required String value,
  }) async {
    return await pref.setString(key, value);
  }

  static String getFromCash({required String key}) {
    return pref.getString(key) ?? "";
  }

  static Future<bool> delete(String key) async {
    return await pref.remove(key);
  }
}
