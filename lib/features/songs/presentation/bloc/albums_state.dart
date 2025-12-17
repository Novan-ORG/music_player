part of 'albums_bloc.dart';

@immutable
final class AlbumsState extends Equatable {
  const AlbumsState({
    this.allAlbums = const [],
    this.status = AlbumsStatus.initial,
    this.sortType = AlbumsSortType.album,
    this.errorMessage,
  });

  final List<Album> allAlbums;
  final AlbumsStatus status;
  final AlbumsSortType sortType;
  final String? errorMessage;

  AlbumsState copyWith({
    List<Album>? allAlbums,
    AlbumsStatus? status,
    AlbumsSortType? sortType,
    String? errorMessage,
  }) {
    return AlbumsState(
      allAlbums: allAlbums ?? this.allAlbums,
      status: status ?? this.status,
      sortType: sortType ?? this.sortType,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    allAlbums,
    status,
    sortType,
    if (errorMessage != null) errorMessage!,
  ];
}

enum AlbumsStatus { initial, loading, loaded, error }
