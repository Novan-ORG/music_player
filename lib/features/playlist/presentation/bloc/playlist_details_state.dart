part of 'playlist_details_bloc.dart';

final class PlaylistDetailsState extends Equatable {
  const PlaylistDetailsState({
    required this.playlist,
    this.status = PlaylistDetailsStatus.initial,
    this.songs = const [],
    this.errorMessage,
  });

  final PlaylistDetailsStatus status;
  final Playlist playlist;
  final String? errorMessage;
  final List<Song> songs;

  PlaylistDetailsState copyWith({
    PlaylistDetailsStatus? status,
    Playlist? playlist,
    String? errorMessage,
    List<Song>? songs,
  }) {
    return PlaylistDetailsState(
      status: status ?? this.status,
      playlist: playlist ?? this.playlist,
      errorMessage: errorMessage ?? this.errorMessage,
      songs: songs ?? this.songs,
    );
  }

  @override
  List<Object?> get props => [
    status,
    playlist,
    errorMessage,
    songs,
  ];
}

enum PlaylistDetailsStatus {
  initial,
  loading,
  success,
  failure,
}
