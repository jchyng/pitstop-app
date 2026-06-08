import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tokens.dart';

final appTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: AppText.fontFamily,
  scaffoldBackgroundColor: AppColors.bg,
  colorScheme: const ColorScheme.dark(
    surface: AppColors.surface,
    primary: AppColors.accent,
    secondary: AppColors.teal,
    error: AppColors.red,
    onSurface: AppColors.textPrimary,
    onPrimary: Colors.white,
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.bg,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
  ),

  // BottomNavigationBar
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xEB0D0F13), // rgba(13,15,19,0.92)
    selectedItemColor: AppColors.accent,
    unselectedItemColor: AppColors.textTertiary,
    selectedLabelStyle: TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: 10,
    ),
    elevation: 0,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),

  // Card
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.card,
      side: const BorderSide(color: AppColors.hairline),
    ),
    margin: EdgeInsets.zero,
  ),

  // Divider
  dividerTheme: const DividerThemeData(
    color: AppColors.hairline,
    thickness: 1,
    space: 0,
  ),

  // InputDecoration
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0x0AFFFFFF), // rgba(255,255,255,0.04)
    border: OutlineInputBorder(
      borderRadius: AppRadius.button,
      borderSide: const BorderSide(color: AppColors.hairline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.button,
      borderSide: const BorderSide(color: AppColors.hairline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.button,
      borderSide: const BorderSide(color: AppColors.accent),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    hintStyle: const TextStyle(
      fontFamily: AppText.fontFamily,
      color: AppColors.textTertiary,
      fontSize: 14,
    ),
    labelStyle: const TextStyle(
      fontFamily: AppText.fontFamily,
      color: AppColors.textSecondary,
      fontSize: 14,
    ),
  ),

  // ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
      textStyle: const TextStyle(
        fontFamily: AppText.fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      elevation: 0,
    ),
  ),

  // TextButton
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.accent,
      textStyle: const TextStyle(
        fontFamily: AppText.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  // Text (global default)
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: AppColors.textTertiary,
    ),
    titleLarge: TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    labelSmall: TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.textTertiary,
    ),
  ),
);
