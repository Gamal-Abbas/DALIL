import 'package:depi_dalil/core/utils/size.dart';
import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class AppTheme {
  static ThemeData darkTheme(BuildContext context) {
    final w = context.screenWidth;


    final fs40 = (w / 10).clamp(40.0, w / 8);
    final fs35 = (w / 11.5).clamp(35.0, w / 9);
    final fs30 = (w / 13).clamp(30.0, w / 10);
    final fs27 = (w / 14.5).clamp(27.0, w / 11);
    final fs23 = (w / 17).clamp(23.0, w / 13);
    final fs20 = (w / 20).clamp(20.0, w / 15);
    final fs18 = (w / 22).clamp(18.0, w / 17);
    final fs16 = (w / 24.5).clamp(16.0, w / 19);
    final fs14 = (w / 28).clamp(14.0, w / 22);
    final iconSize = (w / 16).clamp(24.0, w / 12);
    final radius = (w / 25).clamp(12.0, w / 18);
    final btnRadius = (w / 32).clamp(12.0, w / 22);
    final btnPadH = (w / 16).clamp(24.0, w / 12);
    final btnPadV = (w / 28).clamp(14.0, w / 20);
    final borderWidth = (w / 260).clamp(1.2, 3.0);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primary,
      primaryColor: AppColors.secondary,


      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.secondary),
        titleTextStyle: TextStyle(
          color: AppColors.secondary,
          fontSize: fs20,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.primaryLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.primaryDark,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: AppColors.thirdDark,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.secondary
              : AppColors.primary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.gold_with_opacity_03
              : AppColors.third,
        ),
      ),

      textButtonTheme: TextButtonThemeData(style: ButtonStyle()),

      dividerTheme: const DividerThemeData(
        color: AppColors.white_with_opacity_008,
        thickness: 1,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(w / 20),
        ),
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(color: AppColors.secondary, fontSize: fs40, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppColors.secondary, fontSize: fs35, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: AppColors.secondary, fontSize: fs30, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: AppColors.secondary, fontSize: fs27, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: AppColors.secondary, fontSize: fs23, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: AppColors.secondary, fontSize: fs20, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.secondary, fontSize: fs18, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(color: AppColors.third, fontSize: fs16, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: AppColors.thirdDark, fontSize: fs14, fontWeight: FontWeight.w400),
      ),

      iconTheme: IconThemeData(color: AppColors.secondary, size: iconSize),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(btnRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: btnPadH, vertical: btnPadV),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        hoverColor: Colors.red,
        focusColor: Colors.red,
        filled: true,
        fillColor: AppColors.primaryLight,
        hintStyle: const TextStyle(color: AppColors.secondary),
        enabledBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(btnRadius),
          borderSide: const BorderSide(color: AppColors.white_with_opacity_008),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(btnRadius),
          borderSide: BorderSide(color: AppColors.secondary, width: borderWidth),
        ),
      ),

      colorScheme: const ColorScheme.dark(
        primary: AppColors.secondaryDark,
        secondary: AppColors.primaryDark,
        surface: AppColors.primaryLight,
        error: AppColors.error,
      ),
    );
  }

  static ThemeData lightTheme(BuildContext context) {
    final w = context.screenWidth;

    final fs40 = (w / 10).clamp(40.0, w / 8);
    final fs35 = (w / 11.5).clamp(35.0, w / 9);
    final fs30 = (w / 13).clamp(30.0, w / 10);
    final fs27 = (w / 14.5).clamp(27.0, w / 11);
    final fs23 = (w / 17).clamp(23.0, w / 13);
    final fs20 = (w / 20).clamp(20.0, w / 15);
    final fs18 = (w / 22).clamp(18.0, w / 17);
    final fs16 = (w / 24.5).clamp(16.0, w / 19);
    final fs14 = (w / 28).clamp(14.0, w / 22);
    final iconSize = (w / 16).clamp(24.0, w / 12);
    final radius = (w / 25).clamp(12.0, w / 18);
    final btnRadius = (w / 32).clamp(12.0, w / 22);
    final btnPadH = (w / 16).clamp(24.0, w / 12);
    final btnPadV = (w / 28).clamp(14.0, w / 20);
    final borderWidth = (w / 260).clamp(1.2, 3.0);

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      primaryColor: AppColors.primaryDark,
      hintColor: AppColors.secondary,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryDark),
        titleTextStyle: TextStyle(
          color: AppColors.primaryDark,
          fontSize: fs20,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightCard,
        selectedItemColor: AppColors.secondaryDark,
        unselectedItemColor: AppColors.thirdDark,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.secondaryDark
              : AppColors.thirdDark,
        ),
        trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryLight
              : AppColors.third,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.thirdDark,
        thickness: 1,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(w / 20),
        ),
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(color: AppColors.primaryDark, fontSize: fs40, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppColors.primaryDark, fontSize: fs35, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: AppColors.primaryDark, fontSize: fs30, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(color: AppColors.primaryDark, fontSize: fs27, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: AppColors.primaryDark, fontSize: fs23, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: AppColors.primaryDark, fontSize: fs20, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.primaryDark, fontSize: fs18, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(color: AppColors.primaryDark, fontSize: fs16, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: AppColors.primaryDark, fontSize: fs14, fontWeight: FontWeight.w400),
      ),

      iconTheme: IconThemeData(color: AppColors.primaryDark, size: iconSize),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightCard,
          foregroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(btnRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: btnPadH, vertical: btnPadV),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(

        filled: true,
        fillColor: AppColors.lightCard,
        hintStyle: const TextStyle(color: AppColors.primary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(btnRadius),
          borderSide: const BorderSide(color: AppColors.lightSurface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(btnRadius),
          borderSide: BorderSide(color: AppColors.secondaryDark, width: borderWidth),
        ),
      ),

      colorScheme: const ColorScheme.light(
        primary: AppColors.secondaryDark,
        secondary: AppColors.primaryDark,
        surface: AppColors.lightCard,
        error: AppColors.error,
      ),
    );
  }
}