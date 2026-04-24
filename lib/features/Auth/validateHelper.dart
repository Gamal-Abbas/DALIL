import 'package:easy_localization/easy_localization.dart'; // تم تغيير الـ Import ✅
import 'package:flutter/material.dart';

class ValidationHelper {
  static String? validateName(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'enterName'.tr(); // استخدام tr() ✅
    }
    if (value.length < 3) {
      return 'nameShort'.tr();
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'emailRequiredMessage'.tr();
    }

    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'enterValidDomain'.tr();
    }

    List<String> validDomains = ['.com', '.net', '.org', '.edu', '.eg', '.me'];
    bool hasValidDomain = validDomains.any(
          (domain) => value.toLowerCase().endsWith(domain),
    );

    if (!hasValidDomain) {
      return 'invalidDomain'.tr();
    }

    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'passwordRequired'.tr();
    }
    if (value.length < 8) {
      return 'passwordLength'.tr();
    }
    return null;
  }

  static String? validateConfirmPassword(
      BuildContext context,
      String? value,
      String password,
      ) {
    if (value != password) {
      return 'passwordsNotMatch'.tr();
    }
    return null;
  }
}