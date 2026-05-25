
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../home.dart';
import '../manager/authState.dart';
import 'dialoge.dart';

class BlocListenerLogin {
  final BuildContext context;
  final Authstate state;

  BlocListenerLogin({required this.state, required this.context});

  void listenToBloc_login(BuildContext context, Authstate state) {
    print('listenToBloc_login==============================');
    print(state);
    if (state is AuthSuccess) {
      print('AuthSuccess===========');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => Home()),
      );
    } else if (state is AuthError ||
        state is authVerified ||
        state is AuthDeleted ||
        state is verifySent ||
        state is emailEmpty) {
      handleDialoge_login(context, state);
    }
  }

  void handleDialoge_login(BuildContext context, Authstate state) {
    String title = '';
    String desc = '';
    IconData icon = Icons.info;
    Color iconColor = Colors.orange;
    print('handleDialoge_login==============================');
    // if (state is AuthLoading) return;
    if (state is AuthDeleted) {
      print('authdeleted===========');

      title = 'deleted'.tr();
      desc = state.message;
      icon = Icons.email_outlined;
      iconColor = Colors.orange;
    } else if (state is authVerified) {
      title = 'verify'.tr();
      desc = 'verifyinstructins'.tr();
      icon = Icons.email_outlined;
      iconColor = Colors.orange;
      print('authVerified===========');
    } else if (state is emailEmpty) {
      print('emailEmpty===========');

      title = 'emailRequiredTitle'.tr();
      desc = 'emailRequiredMessage'.tr();
      icon = Icons.email_outlined;
      iconColor = Colors.orange;
    } else if (state is AuthError) {
      print(state.message);
      print('authError===========');

      title = 'error'.tr();
      desc = 'invalidCredentials'.tr();
      icon = Icons.error;
      iconColor = Colors.red;
    } else if (state is verifySent) {
      print('verifySent===========');

      title = 'success'.tr();
      desc = '${'verifyinstructins'.tr()}:\n${state.email}';
      icon = Icons.check_circle_outline;
      iconColor = Colors.green;
    }
    // if (Navigator.canPop(context)) {
    //   Navigator.pop(context);
    // }
    AppDialogs.showCustomDialog(
      context,
      title: title,
      desc: desc,
      icon: icon,
      iconColor: iconColor,
    );
  }
}
