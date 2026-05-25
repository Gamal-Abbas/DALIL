import 'package:depi_dalil/core/utils/size.dart';
import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class AppTheme {
  //  Dark Theme
  static ThemeData darkTheme(BuildContext context) {
    // final h=context.screenHeight;
    final w = context.screenWidth;

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
          fontSize: (w / 20).clamp(18, 30), //20
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.primaryLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(w / 25),
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
          borderRadius: BorderRadius.circular(w / 20), //20
        ),
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.secondary,
          fontSize: (w / 10).clamp(40, 50), //40
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.secondary,
          fontSize: (w / 11.5).clamp(35, 45), //35
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppColors.secondary,
          fontSize: (w / 13).clamp(30, 40), //30
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.secondary,
          fontSize: (w / 14.5).clamp(27, 35), //27
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.secondary,
          fontSize: (w / 17).clamp(23, 33), //23
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: AppColors.secondary,
          fontSize: (w / 20).clamp(20, 30), //20
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppColors.secondary,
          fontSize: (w / 22).clamp(18, 25), //18
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: AppColors.third,
          fontSize: (w / 24.5).clamp(16, 22), //16
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: AppColors.thirdDark,
          fontSize: (w / 28).clamp(14, 18), //14
          fontWeight: FontWeight.w400,
        ),
      ),

      iconTheme: IconThemeData(
        color: AppColors.secondary,
        size: (w / 16).clamp(24, 36), //24
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              (w / 32).clamp(12, 18), //12
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: (w / 16).clamp(24, 36), //24
            vertical: (w / 28).clamp(14, 22), //14
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.primaryLight,
        hintStyle: const TextStyle(color: AppColors.thirdDark),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            (w / 32).clamp(12, 18), //12
          ),
          borderSide: const BorderSide(color: AppColors.white_with_opacity_008),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            (w / 32).clamp(12, 18), //12
          ),
          borderSide: BorderSide(
            color: AppColors.secondary,
            width: (w / 260).clamp(1.2, 3), //1.5
          ),
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

  //  Light Theme
  static ThemeData lightTheme(BuildContext context) {
    // final h = context.screenHeight;
    final w = context.screenWidth;
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      primaryColor: AppColors.primaryDark,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryDark),
        titleTextStyle: TextStyle(
          color: AppColors.primaryDark,
          fontSize: (w / 20).clamp(18, 30), //12
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(w / 25),
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
          borderRadius: BorderRadius.circular(w / 20), //20
        ),
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.primaryDark,
          fontSize: (w / 10).clamp(40, 50),
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.primaryDark,
          fontSize: (w / 11.5).clamp(35, 45), //35
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppColors.primaryDark,
          fontSize: (w / 13).clamp(30, 40), //30
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: AppColors.primaryDark,
          fontSize: (w / 14.5).clamp(27, 35), //27
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.primaryDark,
          fontSize: (w / 17).clamp(23, 33), //23
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: AppColors.primaryDark,
          fontSize: (w / 20).clamp(20, 30), //20
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppColors.primaryDark,
          fontSize: (w / 22).clamp(18, 25), //18
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: AppColors.primaryDark,
          fontSize: (w / 24.5).clamp(16, 22), //16
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: AppColors.primaryDark,
          fontSize: (w / 28).clamp(14, 18), //14
          fontWeight: FontWeight.w400,
        ),
      ),

      iconTheme: IconThemeData(
        color: AppColors.primaryDark,
        size: (w / 16).clamp(24, 36), //24
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightCard,
          foregroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              (w / 32).clamp(12, 18), //12
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: (w / 16).clamp(24, 36), //24
            vertical: (w / 28).clamp(14, 22), //14
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCard,
        hintStyle: const TextStyle(color: AppColors.primaryDark),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            (w / 32).clamp(12, 18), //12
          ),
          borderSide: const BorderSide(color: AppColors.lightSurface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            (w / 32).clamp(12, 18), //12
          ),
          borderSide: BorderSide(
            color: AppColors.secondaryDark,
            width: (w / 260).clamp(1.2, 3), //1.5
          ),
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
