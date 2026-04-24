import 'package:dalil/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class Customtextformfield extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  const Customtextformfield({
    super.key,
    required this.hint,

    required this.textEditingController,

    required this.isPassword,
    this.validator, this.onFieldSubmitted, this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final SH=size.height;
    final SW=size.width;
    print(SH);
    print(SW);
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SW/26),//15
          gapPadding: SW/78,//5
          borderSide: BorderSide(
            color: AppColors.secondaryDark,
            width: 0.099,
            strokeAlign: 0.099,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SW/26),//15
          gapPadding: SW/78,//5
          borderSide: BorderSide(
            color: AppColors.secondaryLight,
            width: 1,
            strokeAlign: 1,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SW/26),//15
          gapPadding: SW/78,//5
        ),

        hintText: hint,
        filled: true,
        fillColor: AppColors.primaryLight,
        hintStyle: TextStyle(
          fontSize: SH/57.5,//14
          color: AppColors.secondaryDark,
          fontWeight: FontWeight.w400,
          letterSpacing: SW/196,//2
        ),
      ),
      style: TextStyle(
        color: AppColors.secondaryLight,
        fontStyle: FontStyle.italic,
      ),
      onFieldSubmitted: onFieldSubmitted,
      controller: textEditingController,
      validator: validator,

      cursorColor: AppColors.secondary,
      obscureText: false,
      cursorHeight: SH/40,//20
      textInputAction: textInputAction,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
