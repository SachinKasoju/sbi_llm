import 'package:flutter/material.dart';

import '../utils/global_colors.dart';


class AppTheme {
  /// Light Theme
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      hoverColor: Colors.transparent,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: const Color(0xffffffff),
      splashColor: Colors.blue.withOpacity(0.2),
      highlightColor: Colors.blue.withOpacity(0.1),
      primarySwatch: AppColors.primarySwatch,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primarySwatch,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // ✅ Rounded corners (12 pixels)
          ),
          backgroundColor: AppColors.secondaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        fillColor: MaterialStateProperty.resolveWith<Color>(
              (states) => states.contains(MaterialState.selected)
              ? AppColors.primarySwatch[700]!
              : Colors.transparent,
        ),
      ),

      textTheme: Theme.of(context).textTheme.apply(
        displayColor: AppColors.primaryTextColor600,
        fontFamily: 'Lexend',
      ),
    );
  }

  /// Dark Theme
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      primaryColor: AppColors.primarySwatch,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primarySwatch,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primarySwatch[700],
          foregroundColor: Colors.white,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        fillColor: MaterialStateProperty.resolveWith<Color>(
              (states) => states.contains(MaterialState.selected)
              ? AppColors.primarySwatch[700]!
              : Colors.grey.shade600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primarySwatch),
        ),
        labelStyle: const TextStyle(color: Colors.white),
      ),
      textTheme: Theme.of(context).textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}
