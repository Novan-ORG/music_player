part of 'songs_bloc.dart';

@immutable
sealed class SongsEvent {
  const SongsEvent();
}

final class LoadSongsEvent extends SongsEvent {
  const LoadSongsEvent();
}
