import 'package:dalil/core/bloc/auth/authBloc.dart';
import 'package:dalil/core/bloc/auth/authState.dart';
import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/features/Auth/authLogo.dart';
import 'package:dalil/features/Auth/register/widgets/haveAccountSection.dart';
import 'package:dalil/features/Auth/register/widgets/listToBloc_register.dart';
import 'package:dalil/features/Auth/register/widgets/signUpButton.dart';
import 'package:dalil/features/Auth/register/widgets/signUpForm.dart';
import 'package:dalil/features/Auth/register/widgets/signUpHeader.dart';
import 'package:dalil/features/Auth/register/widgets/socailSignUpSection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SignupView extends StatefulWidget {
  SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
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
    // final size = MediaQuery.of(context).size;
    // final SH = size.height;
    // final SW = size.width;

    return Scaffold(
      backgroundColor: AppColors.primary,
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
                  email: emailController
                      .text,
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

                    Signupform(
                      formKey: _formKey,
                      nameController: nameController,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      onFieldSubmitted: (v) {
                        onSubmitted();
                      },
                    ),

                    Signupbutton(
                      label: state is AuthLoading
                          ? 'loading'.tr()
                          : 'signUp'.tr(),
                      onPressed: state is AuthLoading
                          ? () {}
                          : () {
                              if (_formKey.currentState!.validate()) {
                                onSubmitted();
                              }
                            },
                    ),
                    const  socialSignUpSection(),

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
