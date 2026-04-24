import 'package:dalil/core/bloc/auth/authBloc.dart';
import 'package:dalil/core/bloc/auth/authState.dart';
import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/customWidgets/customButton.dart';
import 'package:dalil/customWidgets/customText.dart';
import 'package:dalil/customWidgets/customTextformField.dart';
import 'package:dalil/features/Auth/register/views/signUpView.dart';
import 'package:dalil/features/Auth/register/widgets/SignMethode.dart';
import 'package:dalil/features/Auth/register/widgets/dialoge.dart';
import 'package:dalil/features/Auth/validateHelper.dart';
import 'package:dalil/features/home.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final size = MediaQuery.of(context).size;
    final SH = size.height;
    final SW = size.width;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: EdgeInsets.all(SW / 32.5).clamp(const EdgeInsets.all(12), const EdgeInsets.all(40)),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: BlocConsumer<authBloc, Authstate>(
                listener: (context, state) {
                  if (state is AuthDeleted) {
                    AppDialogs.showCustomDialog(
                      context,
                      title: 'deleted'.tr(), // تم التعديل لـ tr() ✅
                      desc: state.message,
                      icon: Icons.email_outlined,
                      iconColor: Colors.orange,
                    );
                  } else if (state is authVerified) {
                    AppDialogs.showCustomDialog(
                      context,
                      title: 'verify'.tr(),
                      desc: 'verifyinstructins'.tr(),
                      icon: Icons.email_outlined,
                      iconColor: Colors.orange,
                    );
                  } else if (state is emailEmpty) {
                    AppDialogs.showCustomDialog(
                      context,
                      title: 'emailRequiredTitle'.tr(),
                      desc: 'emailRequiredMessage'.tr(),
                      icon: Icons.email_outlined,
                      iconColor: Colors.orange,
                    );
                  } else if (state is AuthError) {
                    AppDialogs.showCustomDialog(
                      context,
                      title: 'error'.tr(),
                      desc: 'invalidCredentials'.tr(),
                      icon: Icons.error,
                      iconColor: Colors.red,
                    );
                  } else if (state is verifySent) {
                    AppDialogs.showCustomDialog(
                      context,
                      title: 'success'.tr(),
                      desc: '${'verifyinstructins'.tr()}:\n${state.email}',
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.green,
                    );
                  } else if (state is AuthSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (c) => Home()),
                    );
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<authBloc>();
                  return Column(
                    spacing: (SH / 32).clamp(24, 27),
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
                        text: 'welcomeBack'.tr(),
                        size: (SH / 33.5).clamp(24, 96),
                        color: AppColors.third,
                      ),
                      Customtextformfield(
                        isPassword: false,
                        hint: 'User@gmail.com',
                        textEditingController: emailController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return ValidationHelper.validateEmail(context, value);
                        },
                      ),
                      Customtextformfield(
                        isPassword: true,
                        hint: 'password'.tr(),
                        textEditingController: passwordController,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (v) async {
                          if (_formKey.currentState!.validate()) {
                            await cubit.loginEmail(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        validator: (value) {
                          return ValidationHelper.validatePassword(context, value);
                        },
                      ),
                      customButton(
                        text: 'login'.tr(),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await cubit.loginEmail(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        fontWeight: FontWeight.w700,
                        textSize: (SH / 40.25).clamp(20, 80),
                        buttonWeight: (SW / 1.41).clamp(278, 1300),
                        buttonHeight: (SH / 14.37).clamp(56, 60),
                        buttonColor: AppColors.secondary,
                        textColor: AppColors.primary,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await cubit.handleResetPassword(
                            context: context,
                            email: emailController.text,
                          );
                        },
                        child: Customtext(
                          weight: FontWeight.w400,
                          text: 'forgetPassword'.tr(),
                          size: (SH / 40).clamp(16, 30),
                          color: AppColors.secondaryDark,
                        ),
                      ),
                      Customtext(
                        weight: FontWeight.w400,
                        text: 'orSignInWith'.tr(),
                        size: (SH / 50).clamp(14, 35),
                        color: AppColors.thirdDark,
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
                            text: 'noAccount'.tr(),
                            size: (SH / 40).clamp(14, 35),
                            color: AppColors.thirdDark,
                            weight: FontWeight.w400,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (c) => SignupView()),
                              );
                            },
                            child: Customtext(
                              text: 'signUp'.tr(),
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