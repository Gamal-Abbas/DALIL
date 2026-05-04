import 'package:dalil/customWidgets/customTextformField.dart';
import 'package:dalil/features/Auth/validateHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final Function(String) onLogin;
  const LoginForm({
    super.key,
    required this.onLogin,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Customtextformfield(
            isPassword: false,
            hint: 'User@gmail.com',
            textEditingController: emailController,
            textInputAction: TextInputAction.next,
            validator: (value) {
              return ValidationHelper.validateEmail(context, value);
            },
          ),
          Gap((MediaQuery.sizeOf(context).height)/40),///20
          Customtextformfield(
            isPassword: true,
            hint: 'password'.tr(),
            textEditingController: passwordController,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: onLogin,
            validator: (value) {
              return ValidationHelper.validatePassword(context, value);
            },
          ),
        ],
      ),
    );
  }
}
