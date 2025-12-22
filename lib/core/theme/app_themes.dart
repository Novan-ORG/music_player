import 'package:flutter/material.dart';

/// Dark theme color palette for the Music Player app.
class AppDarkColors {
  static const Color primary = Color(0xFF9C27B0); // Purple
  static const Color background = Color(0xFF181818);
  static const Color surface = Color(0xFF282828);
  static const Color accent = Color(0xFF535353);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);
}

/// Light theme color palette for the Music Player app.
class AppLightColors {
  static const Color primary = Color(0xFF9C27B0); // Purple
  static const Color background = Color(0xFFFDFCF2);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color accent = Color(0xFFE0E0E0);
  static const Color textPrimary = Color(0xFF181818);
  static const Color textSecondary = Color(0xFF535353);
}

/// Custom text theme for the Music Player app.
///
/// Defines text styles for headlines, titles, bodies, and labels
/// with specified primary and secondary text colors.
TextTheme appTextTheme(Color textPrimary, Color textSecondary) => TextTheme(
  headlineLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  ),
  headlineMedium: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  ),
  titleLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    color: textPrimary,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    color: textSecondary,
  ),
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  ),
);

// Dark ThemeData
final ThemeData darkTheme = ThemeData(
  fontFamily: 'Inter',
  fontFamilyFallback: const ['Vazirmatn'],
  brightness: Brightness.dark,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppDarkColors.background,
  ),
  primaryColor: AppDarkColors.primary,
  scaffoldBackgroundColor: AppDarkColors.background,
  canvasColor: AppDarkColors.background,
  cardColor: AppDarkColors.surface,
  secondaryHeaderColor: AppDarkColors.primary,
  sliderTheme: const SliderThemeData(
    activeTrackColor: AppDarkColors.primary,
    inactiveTrackColor: AppDarkColors.accent,
    thumbColor: AppDarkColors.primary,
    trackHeight: 4,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 10,
    backgroundColor: AppDarkColors.surface,
    unselectedItemColor: Colors.white,
    selectedItemColor: AppDarkColors.primary,
  ),
  tabBarTheme: const TabBarThemeData(
    dividerColor: AppDarkColors.accent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppDarkColors.background,
    iconTheme: IconThemeData(color: AppDarkColors.textPrimary),
    titleTextStyle: TextStyle(
      color: AppDarkColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: AppDarkColors.textPrimary),
  textTheme: appTextTheme(
    AppDarkColors.textPrimary,
    AppDarkColors.textSecondary,
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppDarkColors.primary,
    surface: AppDarkColors.surface,
    secondary: AppDarkColors.accent,
    onPrimary: AppDarkColors.textPrimary,
    onSecondary: AppDarkColors.textSecondary,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppDarkColors.primary,
    textTheme: ButtonTextTheme.primary,
  ),
);

// Light ThemeData
final ThemeData lightTheme = ThemeData(
  fontFamily: 'Inter',
  fontFamilyFallback: const ['Vazirmatn'],
  brightness: Brightness.light,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppLightColors.background,
  ),
  primaryColor: AppLightColors.primary,
  scaffoldBackgroundColor: AppLightColors.background,
  canvasColor: AppLightColors.background,
  cardColor: AppLightColors.surface,
  secondaryHeaderColor: AppLightColors.primary,
  sliderTheme: const SliderThemeData(
    activeTrackColor: AppLightColors.primary,
    inactiveTrackColor: AppLightColors.accent,
    thumbColor: AppLightColors.primary,
    trackHeight: 4,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 10,
    backgroundColor: AppLightColors.surface,
    unselectedItemColor: Colors.black,
    selectedItemColor: AppLightColors.primary,
  ),
  tabBarTheme: const TabBarThemeData(
    dividerColor: AppLightColors.accent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppLightColors.background,
    iconTheme: IconThemeData(color: AppLightColors.textPrimary),
    titleTextStyle: TextStyle(
      color: AppLightColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: AppLightColors.textPrimary),
  textTheme: appTextTheme(
    AppLightColors.textPrimary,
    AppLightColors.textSecondary,
  ),
  colorScheme: const ColorScheme.light(
    primary: AppLightColors.primary,
    surface: AppLightColors.surface,
    secondary: AppLightColors.accent,
    onPrimary: AppLightColors.textPrimary,
    onSurface: AppLightColors.textPrimary,
    onSecondary: AppLightColors.textSecondary,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppLightColors.primary,
    textTheme: ButtonTextTheme.primary,
  ),
);
