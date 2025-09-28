part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class ChangeThemeEvent extends SettingsEvent {
  const ChangeThemeEvent(this.mode);
  final String mode;

  @override
  List<Object?> get props => [mode];
}

final class ChangeSleepTimerEvent extends SettingsEvent {
  const ChangeSleepTimerEvent(this.sleepEndTime);
  final DateTime? sleepEndTime;

  @override
  List<Object?> get props => [sleepEndTime];
}

final class ClearSleepTimerEvent extends SettingsEvent {}

final class ChangeLanguageEvent extends SettingsEvent {
  const ChangeLanguageEvent(this.langCode);
  final String langCode;

  @override
  List<Object?> get props => [...super.props, langCode];
}
