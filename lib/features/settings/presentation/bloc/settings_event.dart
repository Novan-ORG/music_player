part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class ChangeThemeEvent extends SettingsEvent {
  final String mode;

  const ChangeThemeEvent(this.mode);

  @override
  List<Object?> get props => [mode];
}

final class ChangeSleepTimerEvent extends SettingsEvent {
  final DateTime? sleepEndTime;

  const ChangeSleepTimerEvent(this.sleepEndTime);

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
