part of 'settings_bloc.dart';

final class SettingsState extends Equatable {
  const SettingsState({this.themeMode = 'system', this.sleepEndTime});

  final String themeMode;
  final DateTime? sleepEndTime;

  SettingsState copyWith({String? themeMode, DateTime? sleepEndTime}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      sleepEndTime: sleepEndTime ?? this.sleepEndTime,
    );
  }

  ThemeMode get currentTheme {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  @override
  List<Object> get props => [
    themeMode,
    if (sleepEndTime != null) sleepEndTime!,
  ];
}
