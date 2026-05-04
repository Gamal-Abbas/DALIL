import 'package:dalil/core/bloc/auth/authBloc.dart';
import 'package:dalil/core/bloc/auth/authState.dart';
import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/features/Auth/authLogo.dart';
import 'package:dalil/features/Auth/forggetPassword.dart';
import 'package:dalil/features/Auth/login/widgets/listenToBloc_Login.dart';
import 'package:dalil/features/Auth/login/widgets/loginButton.dart';
import 'package:dalil/features/Auth/login/widgets/loginForm.dart';
import 'package:dalil/features/Auth/login/widgets/noAccountSection.dart';
import 'package:dalil/features/Auth/login/widgets/socialSignInSection.dart';
import 'package:dalil/features/Auth/login/widgets/welcomeSection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Loginview extends StatefulWidget {
  final String? email;
  final String? password;
  Loginview({super.key, this.email, this.password});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: EdgeInsets.all(
            context.screenWidth / 32.5,
        ).clamp(const EdgeInsets.all(12), const EdgeInsets.all(40)),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: BlocConsumer<authBloc, Authstate>(
              listener: (context, state) {
                print('BlocConsumer=============');

                BlocListenerLogin(
                  state: state,
                  context: context,
                ).listenToBloc_login(context, state);
              },
              listenWhen: (previous, current) {
                print('listenWhen=============');
                if (previous is AuthError && current is AuthError) {
                  return false;
                }
                return previous != current;
              },
              builder: (context, state) {
                print('Builder=============');
                return Column(
                  spacing: ( context.screenHeight / 32).clamp(24, 27),
                  children: [
                    const authLogo(),
                    const welcomeSection(),
                    LoginForm(
                      onLogin: (v) async {
                        onLogin();
                      },

                      emailController: emailController,
                      formKey: _formKey,
                      passwordController: passwordController,
                    ),
                    Loginbutton(onPressed: onLogin),
                    // footer(SH: SH, context: context),
                    Forggetpassword(email: emailController.text),
                    // Gap(SH / 80),
                    const socialSignInSection(),
                    // Gap(SH / 16),

                    const noAccountSection(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void onLogin(

  ) async {
    if (_formKey.currentState!.validate()) {
      await context.read<authBloc>().loginEmail(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

}
