part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

final class ChangeThemeEvent extends SettingsEvent {
  final String mode;

  const ChangeThemeEvent(this.mode);

  @override
  List<Object> get props => [mode];
}
