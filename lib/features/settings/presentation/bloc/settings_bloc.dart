import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/constants/preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.preferences)
    : super(
        SettingsState(
          themeMode:
              preferences.getString(PreferencesKeys.themeMode) ?? 'system',
        ),
      ) {
    on<ChangeThemeEvent>(_onChnageTheme);
  }

  final SharedPreferences preferences;

  void _onChnageTheme(ChangeThemeEvent event, Emitter<SettingsState> emit) {
    final oldMode = preferences.getString(PreferencesKeys.themeMode);
    if (oldMode == event.mode) return;
    preferences.setString(PreferencesKeys.themeMode, event.mode);
    emit(state.copyWith(themeMode: event.mode));
  }
}
