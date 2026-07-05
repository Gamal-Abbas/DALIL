import 'package:easy_localization/easy_localization.dart'; // تم تغيير الـ Import ✅
import 'package:flutter/material.dart';

class ValidationHelper {
  static String? validateName( String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'enterName'.tr();
    }
    if (value.length < 3) {
      return 'nameShort'.tr();
    }
    return null;
  }

  static String? validateEmail( String? value) {
    print('validate email==================00');
    if (value == null || value.trim().isEmpty) {
      print('value == null || value.trim().isEmpty');
      return 'emailRequiredMessage'.tr();
    }

    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );

    if (!emailRegExp.hasMatch(value)) {
      print('!emailRegExp.hasMatch(value)');
      return 'enterValidDomain'.tr();
    }

    List<String> validDomains = ['.com', '.net', '.org', '.edu', '.eg', '.me'];
    bool hasValidDomain = validDomains.any(
      (domain) => value.toLowerCase().endsWith(domain),
    );

    if (!hasValidDomain) {
      print('!hasValidDomain');
      return 'invalidDomain'.tr();
    }

    return null;
  }

  static String? validatePassword( String? value) {
    if (value == null || value.isEmpty) {
      return 'passwordRequired'.tr();
    }
    if (value.length < 8) {
      return 'passwordLength'.tr();
    }
    return null;
  }

  static String? validateConfirmPassword(

    String? value,
    String password,
  ) {
    if (value != password) {
      return 'passwordsNotMatch'.tr();
    }
    return null;
  }
}
