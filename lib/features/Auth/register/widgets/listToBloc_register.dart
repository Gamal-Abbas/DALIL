import 'package:dalil/core/bloc/auth/authState.dart';
import 'package:dalil/features/Auth/login/views/loginView.dart';
import 'package:dalil/features/Auth/register/widgets/dialoge.dart';
import 'package:dalil/features/home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BlocListenerRegister {
  final BuildContext context;
  final Authstate state;

  BlocListenerRegister({required this.state, required this.context});

  void listenToBloc_register(
    Authstate state, {
    required BuildContext context,
    required String password,
    required String email,
  }) {
    if (state is AuthSuccess) {
      if (state.Google == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const Home()),
        );
      } else {
        handleDialoge_register(context, state);

        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (c) => Loginview(email: email, password: password),
              ),
            );
          }
        });
      }
    } else if (state is AuthError) {
      handleDialoge_register(context, state);
    }
  }

  void handleDialoge_register(BuildContext context, Authstate state) {
    String title = '';
    String desc = '';
    IconData icon = Icons.email_outlined;
    Color iconColor = Colors.orange;
    if (state is AuthSuccess) {
      title = 'verify'.tr();
      desc = 'verifyinstructins'.tr();
      icon = Icons.email_outlined;
      iconColor = Colors.orange;
    } else if (state is AuthError) {
      title = 'error'.tr();
      desc = state.message;
      icon = Icons.error;
      iconColor = Colors.red;
    }

    AppDialogs.showCustomDialog(
      context,
      title: title,
      desc: desc,
      icon: icon,
      iconColor: iconColor,
    );
  }
}
