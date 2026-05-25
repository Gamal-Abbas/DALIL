import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/cash.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/theme/theme_extension.dart';

class LangOption extends StatelessWidget {
  final String label;
  final String code;

  const LangOption({required this.label, required this.code});

  @override
  Widget build(BuildContext context) {
    final isSelected = context.locale.languageCode == code;
    return GestureDetector(
      onTap: () async {
        await context.setLocale(Locale(code));
        await cash.setLang(code);
        if (context.mounted) Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary.withOpacity(0.1)
              : context.scaffoldBg,
          borderRadius: BorderRadius.circular(12),
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
              Icon(Icons.check, ),
          ],
        ),
      ),
    );
  }
}