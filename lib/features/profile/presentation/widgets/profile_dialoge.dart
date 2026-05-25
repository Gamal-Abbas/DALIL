import 'package:depi_dalil/core/theme/text_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_extension.dart';
import '../manager/profile_cubit.dart';
import 'lang_option.dart';

abstract class ProfileDialog {
  static void showEditNameDialog({required BuildContext context
    ,required String currentName}) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('editName'.tr(), style: context.title23),
        content: TextField(
          controller: controller,
          style: context.body18,
          cursorColor: context.colorScheme.primary,
          decoration: InputDecoration(
            hintText: 'name'.tr(),
            hintStyle: context.body18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel'.tr(),
              style: context.body14?.copyWith(color: context.textHint),
            ),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ProfileCubit>().updateName(controller.text);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              'save'.tr(),

            ),
          ),
        ],
      ),
    );
  }

static   void showLanguageSheet({ required BuildContext context}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.textHint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          LangOption(label:  'English (US)',code:  'en'),
          const SizedBox(height: 12),
          LangOption( label: 'العربية', code: 'ar'),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}




}
