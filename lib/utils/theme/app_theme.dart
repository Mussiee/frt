import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color background = Color(0xFF000000); // Pure black as per Figma
  static const Color surface = Color(0xFF121212); // Figma Name Input base 
  static const Color surfaceVariant = Color(0xFF1A1A1A);
  static const Color amber = Color(0xFFF59E0B); // Figma accent 1
  static const Color amberDark = Color(0xFFD97706);
  static const Color successHighlight = Color(0xFF4EDEA3); // Figma Phone screen accent
  static const Color white = Colors.white;
  static const Color grey = Color(0xFFA1A1AA);
  static const Color greyDark = Color(0xFF52525B);
  static const Color inputBorder = Color(0xFF27272A);
  static const Color inputFocusBorder = Color(0xFFF59E0B);
  static const Color fieldBg = Color(0xFF121212); // Figma Name Input field bg
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.amber,
          surface: AppColors.surface,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.white,
            fontSize: 38,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
          headlineMedium: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
          titleMedium: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            color: AppColors.grey,
            fontSize: 14,
            height: 1.6,
          ),
          labelSmall: TextStyle(
            color: AppColors.amber,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.amber,
            foregroundColor: AppColors.background,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              letterSpacing: 1.5,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.fieldBg,
          labelStyle: const TextStyle(color: AppColors.grey, fontSize: 12),
          hintStyle: const TextStyle(color: AppColors.greyDark),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
          ),
        ),
      );
}
