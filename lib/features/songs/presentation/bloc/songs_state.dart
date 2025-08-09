part of 'songs_bloc.dart';

@immutable
final class SongsState {
  final List<SongModel> songs;
  final SongsStatus status;

  const SongsState({
    this.songs = const [],
    this.status = SongsStatus.initial,
  });

  SongsState copyWith({
    List<SongModel>? songs,
    SongsStatus? status,
  }) {
    return SongsState(
      songs: songs ?? this.songs,
      status: status ?? this.status,
    );
  }
}

enum SongsStatus {
  initial,
  loading,
  loaded,
  error,
}
