import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/constants/preferences_keys.dart';
import 'package:music_player/core/services/audio_handler/m_audio_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.preferences, this.audioHandler, this.systemLangCode)
    : super(
        SettingsState(
          themeMode:
              preferences.getString(PreferencesKeys.themeMode) ?? 'system',
          currentLocale: Locale(
            preferences.getString(PreferencesKeys.currentLangCode) ??
                systemLangCode,
          ),
        ),
      ) {
    on<ChangeThemeEvent>(_onChangeTheme);
    on<ChangeSleepTimerEvent>(_onSleepTimer);
    on<ClearSleepTimerEvent>(_onTimerClear);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  final SharedPreferences preferences;
  final MAudioHandler audioHandler;
  final String systemLangCode;

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentLangCode =
        preferences.getString(PreferencesKeys.currentLangCode) ??
        systemLangCode;
    if (currentLangCode == event.langCode) {
      return;
    } else {
      await preferences.setString(
        PreferencesKeys.currentLangCode,
        event.langCode,
      );
      emit(state.copyWith(currentLocale: Locale(event.langCode)));
    }
  }

  Future<void> _onTimerClear(
    ClearSleepTimerEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await preferences.remove(PreferencesKeys.sleepTimer);
    emit(
      SettingsState(
        themeMode: state.themeMode,
        currentLocale: state.currentLocale,
      ),
    );
  }

  Future<void> _onSleepTimer(
    ChangeSleepTimerEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (event.sleepEndTime == null) {
      await preferences.remove(PreferencesKeys.sleepTimer);
      audioHandler.cancelSleepTimer();
      emit(
        SettingsState(
          themeMode: state.themeMode,
          currentLocale: state.currentLocale,
        ),
      );
      return;
    }
    // Save the DateTime as an ISO8601 string in preferences
    final oldSleepEndTime = preferences.getString(PreferencesKeys.sleepTimer);
    final newSleepEndTimeStr = event.sleepEndTime!.toIso8601String();
    if (oldSleepEndTime == newSleepEndTimeStr) return;
    await preferences.setString(PreferencesKeys.sleepTimer, newSleepEndTimeStr);

    final remainedDuration = event.sleepEndTime!.difference(DateTime.now());
    audioHandler.setSleepTimer(remainedDuration);
    emit(state.copyWith(sleepEndTime: event.sleepEndTime));
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final oldMode = preferences.getString(PreferencesKeys.themeMode);
    if (oldMode == event.mode) return;
    await preferences.setString(PreferencesKeys.themeMode, event.mode);
    emit(state.copyWith(themeMode: event.mode));
  }
}
