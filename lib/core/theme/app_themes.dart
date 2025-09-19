import 'package:flutter/material.dart';

// Define custom colors for dark theme
class AppDarkColors {
  static const Color primary = Color(0xFF9C27B0); // Purple
  static const Color background = Color(0xFF181818);
  static const Color surface = Color(0xFF282828);
  static const Color accent = Color(0xFF535353);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);
}

// Define custom colors for light theme
class AppLightColors {
  static const Color primary = Color(0xFF9C27B0); // Purple
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF5F5F5);
  static const Color accent = Color(0xFFE0E0E0);
  static const Color textPrimary = Color(0xFF181818);
  static const Color textSecondary = Color(0xFF535353);
}

// Define custom text styles
TextTheme appTextTheme(Color textPrimary, Color textSecondary) => TextTheme(
  headlineLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    fontFamily: 'Montserrat',
  ),
  headlineMedium: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    fontFamily: 'Montserrat',
  ),
  titleLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    fontFamily: 'Montserrat',
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    color: textPrimary,
    fontFamily: 'Montserrat',
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    color: textSecondary,
    fontFamily: 'Montserrat',
  ),
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    fontFamily: 'Montserrat',
  ),
);

// Dark ThemeData
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: AppDarkColors.background,
  ),
  primaryColor: AppDarkColors.primary,
  scaffoldBackgroundColor: AppDarkColors.background,
  canvasColor: AppDarkColors.background,
  cardColor: AppDarkColors.surface,
  secondaryHeaderColor: AppDarkColors.primary,
  appBarTheme: AppBarTheme(
    backgroundColor: AppDarkColors.surface,
    iconTheme: IconThemeData(color: AppDarkColors.textPrimary),
    titleTextStyle: TextStyle(
      color: AppDarkColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    ),
    elevation: 0,
  ),
  iconTheme: IconThemeData(color: AppDarkColors.textPrimary),
  textTheme: appTextTheme(
    AppDarkColors.textPrimary,
    AppDarkColors.textSecondary,
  ),
  colorScheme: ColorScheme.dark(
    primary: AppDarkColors.primary,
    surface: AppDarkColors.surface,
    secondary: AppDarkColors.accent,
    onPrimary: AppDarkColors.textPrimary,
    onSurface: AppDarkColors.textPrimary,
    onSecondary: AppDarkColors.textSecondary,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppDarkColors.primary,
    textTheme: ButtonTextTheme.primary,
  ),
);

// Light ThemeData
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: AppLightColors.background,
  ),
  primaryColor: AppLightColors.primary,
  scaffoldBackgroundColor: AppLightColors.background,
  canvasColor: AppLightColors.background,
  cardColor: AppLightColors.surface,
  secondaryHeaderColor: AppLightColors.primary,
  appBarTheme: AppBarTheme(
    backgroundColor: AppLightColors.surface,
    iconTheme: IconThemeData(color: AppLightColors.textPrimary),
    titleTextStyle: TextStyle(
      color: AppLightColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    ),
    elevation: 0,
  ),
  iconTheme: IconThemeData(color: AppLightColors.textPrimary),
  textTheme: appTextTheme(
    AppLightColors.textPrimary,
    AppLightColors.textSecondary,
  ),
  colorScheme: ColorScheme.light(
    primary: AppLightColors.primary,
    surface: AppLightColors.surface,
    secondary: AppLightColors.accent,
    onPrimary: AppLightColors.textPrimary,
    onSurface: AppLightColors.textPrimary,
    onSecondary: AppLightColors.textSecondary,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppLightColors.primary,
    textTheme: ButtonTextTheme.primary,
  ),
);
