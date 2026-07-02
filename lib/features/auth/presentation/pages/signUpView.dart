import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../manager/authBloc.dart';
import '../manager/authState.dart';
import '../widgets/authLogo.dart';
import '../widgets/haveAccountSection.dart';
import '../widgets/listToBloc_register.dart';
import '../widgets/signUpButton.dart';
import '../widgets/signUpForm.dart';
import '../widgets/signUpHeader.dart';
import '../widgets/socailSignUpSection.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: SingleChildScrollView(
            child: BlocConsumer<authBloc, Authstate>(
              listener: (context, state) {
                BlocListenerRegister(
                  context: context,
                  state: state,
                ).listenToBloc_register(
                  state,
                  context: context,
                  email: emailController.text,
                  password: passwordController.text,
                );
              },
              listenWhen: (previous, current) {
                print('listenWhen=============');
                if (previous is AuthError && current is AuthError) {
                  return false;
                }
                return previous != current;
              },
              builder: (context, state) {
                return Column(
                  spacing: (context.screenHeight / 30).clamp(22, 25),
                  children: [
                    Gap(context.screenHeight / 20),
                    const authLogo(),
                    const SignUpHeader(),
                    SignUpForm(
                      formKey: _formKey,
                      nameController: nameController,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      onFieldSubmitted: (v) {
                        onSubmitted();
                      },
                    ),
                    SignUpButton(
                      label: state is AuthLoading ? 'loading'.tr() : 'signUp'.tr(),
                      onPressed: state is AuthLoading
                          ? () {}
                          : () {
                        if (_formKey.currentState!.validate()) {
                          onSubmitted();
                        }
                      },
                    ),
                    const SocialSignUpSection(),
                    const Haveaccountsection(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void onSubmitted() async {
    if (_formKey.currentState!.validate()) {
      context.read<authBloc>().signupEmail(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      );
    }
  }
}