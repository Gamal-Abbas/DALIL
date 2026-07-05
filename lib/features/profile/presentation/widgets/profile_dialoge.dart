import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../auth/presentation/manager/authBloc.dart';
import '../../../auth/presentation/manager/authState.dart';
import '../manager/profile_cubit.dart';
import 'lang_option.dart';

abstract class ProfileDialog {
  static void showChangePasswordDialog({required BuildContext context}) {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final bloc = context.read<authBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final width = dialogContext.screenWidth;
        final height = dialogContext.screenHeight;

        return BlocProvider.value(
          value: bloc,
          child: AlertDialog(
            backgroundColor: dialogContext.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width / 16),
            ),
            contentPadding: EdgeInsets.fromLTRB(
              width / 16, height / 50, width / 16, 0,
            ),
            title: Row(
              children: [
                Icon(Icons.lock_outline,
                    color: dialogContext.colorScheme.primary,
                    size: width / 18),
                SizedBox(width: width / 40),
                Text('change_password'.tr(), style: dialogContext.title23),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: height / 100),
                _PasswordField(
                  controller: currentPassController,
                  hint: 'current_password'.tr(),
                ),
                SizedBox(height: height / 80),
                _PasswordField(
                  controller: newPassController,
                  hint: 'new_password'.tr(),
                ),
                SizedBox(height: height / 100),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'cancel'.tr(),
                  style: dialogContext.body14?.copyWith(
                    color: dialogContext.textHint,
                  ),
                ),
              ),
              BlocConsumer<authBloc, Authstate>(
                listener: (ctx, state) {
                  if (state is AuthSuccess) {
                    Navigator.pop(dialogContext);
                    _showSnackBar(context, 'password_changed'.tr(),
                        success: true);
                  }
                  if (state is AuthError) {
                    _showSnackBar(context, state.message, success: false);
                  }
                },
                builder: (ctx, state) {
                  if (state is AuthLoading) {
                    return SizedBox(
                      width: width / 20,
                      height: width / 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: dialogContext.colorScheme.primary,
                      ),
                    );
                  }
                  return TextButton(
                    onPressed: () {
                      final current = currentPassController.text;
                      final newPass = newPassController.text;

                      if (current == newPass) {
                        _showSnackBar(context, 'same_password'.tr(),
                            success: false);
                        return;
                      }
                      if (newPass.length < 8) {
                        _showSnackBar(context, 'passwordLength'.tr(),
                            success: false);
                        return;
                      }
                      ctx.read<authBloc>().changePassword(
                        currentPassword: current,
                        newPassword: newPass,
                      );
                    },
                    child: Text(
                      'save'.tr(),
                      style: TextStyle(color: dialogContext.colorScheme.primary),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showSnackBar(BuildContext context, String message,
      {required bool success}) {
    final width = context.screenWidth;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E1E1E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width / 30),
        ),
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error_outline,
              color: success ? const Color(0xFFD4A843) : Colors.redAccent,
              size: width / 18,
            ),
            SizedBox(width: width / 40),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: success ? const Color(0xFFD4A843) : Colors.redAccent,
                  fontSize: width / 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showEditNameDialog(
      {required BuildContext context, required String currentName}) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (dialogContext) {
        final width = dialogContext.screenWidth;
        final height = dialogContext.screenHeight;

        return AlertDialog(
          backgroundColor: dialogContext.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width / 16),
          ),
          contentPadding: EdgeInsets.fromLTRB(
            width / 16, height / 50, width / 16, 0,
          ),
          title: Text('editName'.tr(), style: dialogContext.title23),
          content: TextField(
            controller: controller,
            style: dialogContext.body18,
            cursorColor: dialogContext.colorScheme.primary,
            decoration: InputDecoration(
              hintText: 'name'.tr(),
              hintStyle: dialogContext.body18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'cancel'.tr(),
                style: dialogContext.body14?.copyWith(
                  color: dialogContext.textHint,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await context.read<ProfileCubit>().updateName(controller.text);
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: Text('save'.tr()),
            ),
          ],
        );
      },
    );
  }

  static void showLanguageSheet({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final width = sheetContext.screenWidth;
        final height = sheetContext.screenHeight;

        return Padding(
          padding: EdgeInsets.all(width / 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: width / 10,
                height: height / 200,
                decoration: BoxDecoration(
                  color: sheetContext.textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: height / 40),
              const LangOption(label: 'English (US)', code: 'en'),
              const LangOption(label: 'العربية', code: 'ar'),
              SizedBox(height: height / 80),
            ],
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  const _PasswordField({required this.controller, required this.hint});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;

    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      style: context.body18,
      cursorColor: context.colorScheme.primary,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: context.body14?.copyWith(color: context.textHint),
        filled: true,
        fillColor: context.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width / 30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: context.textHint,
            size: width / 18,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}