import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/constants/preferences_keys.dart';
import 'package:music_player/core/services/audio_handler/m_audio_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.preferences, this.audioHandler)
    : super(
        SettingsState(
          themeMode:
              preferences.getString(PreferencesKeys.themeMode) ?? 'system',
        ),
      ) {
    on<ChangeThemeEvent>(_onChangeTheme);
    on<ChangeSleepTimerEvent>(_onSleepTimer);
    on<ClearSleepTimerEvent>(_onTimerClear);
  }

  final SharedPreferences preferences;
  final MAudioHandler audioHandler;

  void _onTimerClear(ClearSleepTimerEvent event, Emitter<SettingsState> emit) {
    preferences.remove(PreferencesKeys.sleepTimer);
    emit(SettingsState(themeMode: state.themeMode, sleepEndTime: null));
  }

  void _onSleepTimer(ChangeSleepTimerEvent event, Emitter<SettingsState> emit) {
    if (event.sleepEndTime == null) {
      preferences.remove(PreferencesKeys.sleepTimer);
      audioHandler.cancelSleepTimer();
      emit(SettingsState(themeMode: state.themeMode, sleepEndTime: null));
      return;
    }
    // Save the DateTime as an ISO8601 string in preferences
    final oldSleepEndTime = preferences.getString(PreferencesKeys.sleepTimer);
    final newSleepEndTimeStr = event.sleepEndTime!.toIso8601String();
    if (oldSleepEndTime == newSleepEndTimeStr) return;
    preferences.setString(PreferencesKeys.sleepTimer, newSleepEndTimeStr);

    final remainedDuration = event.sleepEndTime!.difference(DateTime.now());
    audioHandler.setSleepTimer(remainedDuration);
    emit(state.copyWith(sleepEndTime: event.sleepEndTime));
  }

  void _onChangeTheme(ChangeThemeEvent event, Emitter<SettingsState> emit) {
    final oldMode = preferences.getString(PreferencesKeys.themeMode);
    if (oldMode == event.mode) return;
    preferences.setString(PreferencesKeys.themeMode, event.mode);
    emit(state.copyWith(themeMode: event.mode));
  }
}
