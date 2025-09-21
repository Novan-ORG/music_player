import 'package:flutter/material.dart';
import 'package:music_player/localization/app_localizations.dart';

extension ContextEX on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
}
