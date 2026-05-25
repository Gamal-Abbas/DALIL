import 'package:flutter/material.dart';

import '../core/theme/theme_extension.dart';
import '../core/utils/size.dart';

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
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final double gapPadding = context.screenWidth / 78;
    final double borderRadius = context.screenWidth / 26;
    final double fontSize = context.screenHeight / 57.5;
    final double letterSpacing = context.screenWidth / 196;
    final double cursorHeight = context.screenHeight / 40;

    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          gapPadding: gapPadding,
          borderSide: BorderSide(
            color: context.primary,
            width: 0.099,
            strokeAlign: 0.099,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          gapPadding: gapPadding,
          borderSide: BorderSide(
            color: context.colorScheme.secondary,
            width: 1,
            strokeAlign: 1,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          gapPadding: gapPadding,
        ),
        hintText: hint,
        filled: true,
        fillColor: context.cardColor,
        hintStyle: TextStyle(
          fontSize: fontSize,
          color: context.primary,
          fontWeight: FontWeight.w400,
          letterSpacing: letterSpacing,
        ),
      ),
      style: TextStyle(
        color: context.colorScheme.secondary,
        fontStyle: FontStyle.italic,
      ),
      onFieldSubmitted: onFieldSubmitted,
      controller: textEditingController,
      validator: validator,
      cursorColor: context.colorScheme.primary,
      obscureText: isPassword,
      cursorHeight: cursorHeight,
      textInputAction: textInputAction,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}