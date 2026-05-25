import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/cash.dart';
import '../../../auth/presentation/manager/authBloc.dart';

class SettingsCubit extends Cubit<void> {
  SettingsCubit() : super(null);

  Future<void> changeLanguage(BuildContext context, String langCode) async {
    await context.setLocale(Locale(langCode));
    await cash.setLang(langCode);
  }

  // Future<void> logout(BuildContext context) async {
  //   try {
  //     await Future.wait([
  //       context.read<authBloc>().signOut_Email(),
  //       context.read<authBloc>().signOut_Google(),
  //     ]);
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }
}
