import 'package:flutter/material.dart';

extension TextThemeX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Headlines
  TextStyle? get headline40 => textTheme.headlineLarge;
  TextStyle? get headline35 => textTheme.headlineMedium;
  TextStyle? get headline30 => textTheme.headlineSmall;

  // Titles
  TextStyle? get title27 => textTheme.titleLarge;
  TextStyle? get title23 => textTheme.titleMedium;
  TextStyle? get title20 => textTheme.titleSmall;

  // Body
  TextStyle? get body18 => textTheme.bodyLarge;
  TextStyle? get body16 => textTheme.bodyMedium;
  TextStyle? get body14 => textTheme.bodySmall;

  // // Labels
  // TextStyle? get labelLg => textTheme.labelLarge;
  // TextStyle? get labelMd => textTheme.labelMedium;
  // TextStyle? get labelSm => textTheme.labelSmall;
}