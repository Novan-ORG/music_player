part of 'settings_bloc.dart';

final class SettingsState extends Equatable {
  const SettingsState({
    required this.currentLocale,
    this.themeMode = 'system',
    this.sleepEndTime,
  });

  final String themeMode;
  final Locale currentLocale;
  final DateTime? sleepEndTime;

  SettingsState copyWith({
    String? themeMode,
    DateTime? sleepEndTime,
    Locale? currentLocale,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      currentLocale: currentLocale ?? this.currentLocale,
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
    currentLocale,
  ];
}
