import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/cash.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';

class LangOption extends StatelessWidget {
  final String label;
  final String code;

  const LangOption({super.key, required this.label, required this.code});

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;
    final width = context.screenWidth;
    final isSelected = context.locale.languageCode == code;

    return GestureDetector(
      onTap: () async {
        await context.setLocale(Locale(code));
        await cash.setLang(code);
        if (context.mounted) Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: height / 120),
        padding: EdgeInsets.symmetric(
          horizontal: width / 24,
          vertical: height / 70,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary.withOpacity(0.1)
              : context.scaffoldBg,
          borderRadius: BorderRadius.circular(width / 30),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.textHint.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: context.body16),
            if (isSelected)
              Icon(
                Icons.check,
                color: context.colorScheme.primary,
                size: width / 18,
              ),
          ],
        ),
      ),
    );
  }
}