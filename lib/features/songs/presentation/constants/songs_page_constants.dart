import 'package:flutter/material.dart';

/// Constants used throughout the Songs feature
class SongsPageConstants {
  // Private constructor to prevent instantiation
  SongsPageConstants._();
  // Colors
  static const appBarColor = Color(0xFF7F53AC);

  // Sizes
  static const searchIconSize = 28.0;
  static const fabIconSize = 28.0;
  static const toolbarHeight = 56.0; // Standard toolbar height

  // Durations
  static const undoSnackbarDuration = Duration(seconds: 20);
  static const defaultSnackbarDuration = Duration(seconds: 3);

  // Padding and Margins
  static const listVerticalPadding = 12.0;
  static const listHorizontalPadding = 8.0;
  static const addButtonPadding = 8.0;
  static const minPlayerHeight = 80.0;
  static const headerSpacing = 8.0;

  // Text Styles
  static const appBarFontSize = 26.0;
  static const appBarLetterSpacing = 1.2;
}
