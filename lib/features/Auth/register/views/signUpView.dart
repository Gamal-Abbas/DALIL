import 'package:dalil/bloc/auth/authBloc.dart';
import 'package:dalil/bloc/auth/authState.dart';
import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/customWidgets/customButton.dart';
import 'package:dalil/customWidgets/customText.dart';
import 'package:dalil/customWidgets/customTextformField.dart';
import 'package:dalil/features/Auth/login/views/loginView.dart';
import 'package:dalil/features/Auth/register/widgets/dialoge.dart';
import 'package:dalil/features/Auth/validateHelper.dart';
import 'package:dalil/features/home.dart';
// تم تغيير الـ Import هنا ✅
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/SignMethode.dart';

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
    final size = MediaQuery.of(context).size;
    final SH = size.height;
    final SW = size.width;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: BlocConsumer<authBloc, Authstate>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    if (state.Google == null || state.Google == false) {
                      AppDialogs.showCustomDialog(
                        context,
                        title: 'verify'.tr(), // تم التعديل ✅
                        desc: 'verifyinstructins'.tr(),
                        icon: Icons.email_outlined,
                        iconColor: Colors.orange,
                      );
                      Future.delayed(const Duration(seconds: 3), () {
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (c) => Loginview(
                                password: passwordController.text,
                                email: emailController.text,
                              ),
                            ),
                          );
                        }
                      });
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) => Home()),
                      );
                    }
                  } else if (state is AuthError) {
                    AppDialogs.showCustomDialog(
                      context,
                      title: 'error'.tr(),
                      desc: state.message,
                      icon: Icons.error,
                      iconColor: Colors.red,
                    );
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<authBloc>();
                  return Column(
                    spacing: (SH / 30).clamp(22, 25),
                    children: [
                      Text(
                        'dalil'.tr(),
                        style: TextStyle(
                          letterSpacing: (SW / 78).clamp(5, 20),
                          fontWeight: FontWeight.bold,
                          fontSize: (SH / 13).clamp(52, 104),
                          color: AppColors.secondary,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: AppColors.secondaryLight,
                              blurRadius: 12,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                      ),
                      Customtext(
                        weight: FontWeight.w400,
                        text: 'slogan'.tr(),
                        size: (SH / 65).clamp(12, 48),
                        color: AppColors.thirdDark,
                      ),
                      Customtext(
                        weight: FontWeight.w800,
                        text: 'createAccount'.tr(),
                        size: (SH / 33.5).clamp(24, 96),
                        color: AppColors.third,
                      ),

                      /// name
                      Customtextformfield(
                        hint: 'fullName'.tr(),
                        isPassword: false,
                        textEditingController: nameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return ValidationHelper.validateName(context, value);
                        },
                      ),

                      /// email
                      Customtextformfield(
                        textInputAction: TextInputAction.next,
                        isPassword: false,
                        hint: 'User@gmail.com',
                        textEditingController: emailController,
                        validator: (value) {
                          return ValidationHelper.validateEmail(context, value);
                        },
                      ),

                      /// password
                      Customtextformfield(
                        isPassword: true,
                        hint: 'password'.tr(),
                        textEditingController: passwordController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return ValidationHelper.validatePassword(context, value);
                        },
                      ),

                      /// confirm password
                      Customtextformfield(
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (v) async {
                          if (_formKey.currentState!.validate()) {
                            cubit.signupEmail(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        isPassword: true,
                        hint: 'confirmPassword'.tr(),
                        textEditingController: confirmPasswordController,
                        validator: (value) {
                          return ValidationHelper.validateConfirmPassword(
                            context,
                            value,
                            passwordController.text,
                          );
                        },
                      ),

                      customButton(
                        text: state is AuthLoading
                            ? 'loading'.tr()
                            : 'signUp'.tr(),
                        onPressed: state is AuthLoading
                            ? () {}
                            : () {
                          if (_formKey.currentState!.validate()) {
                            cubit.signupEmail(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        textSize: (SH / 40.25).clamp(20, 80),
                        buttonWeight: (SW / 1.41).clamp(278, 1300),
                        buttonHeight: (SH / 14.37).clamp(56, 60),
                        fontWeight: FontWeight.w700,
                        buttonColor: AppColors.secondary,
                        textColor: AppColors.primary,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.primaryLight,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Customtext(
                              text: 'orSignupWith'.tr(),
                              size: (SH / 50).clamp(14, 30),
                              color: AppColors.thirdDark,
                              weight: FontWeight.w400,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.primaryLight,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      Signmethode(
                        googleontap: () async {
                          await cubit.signInWithGoogle();
                        },
                        facebookontap: () {},
                        appleontap: () {},
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Customtext(
                            text: 'haveAcount'.tr(),
                            size: (SH / 40).clamp(14, 35),
                            color: AppColors.thirdDark,
                            weight: FontWeight.w400,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (c) => Loginview()),
                              );
                            },
                            child: Customtext(
                              text: 'login'.tr(),
                              size: (SH / 50).clamp(15, 35),
                              color: AppColors.secondary,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}