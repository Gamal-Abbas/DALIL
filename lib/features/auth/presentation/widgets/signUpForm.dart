
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/utils/size.dart';
import '../../../../core/utils/validateHelper.dart';
import '../../../../customWidgets/customTextformField.dart';

class Signupform extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Function(String) onFieldSubmitted;

  const Signupform({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: (context.screenHeight) / 40,
        children: [
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
            onFieldSubmitted: onFieldSubmitted,
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
        ],
      ),
    );
  }
}
