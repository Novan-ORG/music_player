part of 'settings_bloc.dart';

final class SettingsState extends Equatable {
  const SettingsState({this.themeMode = 'system'});

  final String themeMode;

  SettingsState copyWith({String? themeMode}) {
    return SettingsState(themeMode: themeMode ?? this.themeMode);
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
  List<Object> get props => [themeMode];
}
