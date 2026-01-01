import 'package:flutter/material.dart';
import 'package:music_player/localization/app_localizations.dart';

/// Extension on BuildContext for easy access to localization and theme.
///
/// Provides:
/// - `localization` - Access to AppLocalizations
/// - `theme` - Access to ThemeData
extension ContextEX on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
  ThemeData get theme => Theme.of(this);
}
