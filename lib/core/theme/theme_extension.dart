import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Scaffold
  Color get scaffoldBg => Theme.of(this).scaffoldBackgroundColor;

  // Primary & Secondary
  Color get primary => Theme.of(this).primaryColor;
  Color get secondary => Theme.of(this).colorScheme.secondary;

  // Card
  Color get cardColor => Theme.of(this).cardTheme.color!;

  // Icons
  Color get iconColor => Theme.of(this).iconTheme.color!;

  // Text Colors
  Color get textPrimary => Theme.of(this).textTheme.headlineLarge!.color!;
  Color get textSecondary => Theme.of(this).textTheme.bodyMedium!.color!;
  Color get textHint => Theme.of(this).textTheme.bodySmall!.color!;

 }