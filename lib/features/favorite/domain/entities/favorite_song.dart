import 'package:equatable/equatable.dart';

/// Represents a song that has been added to favorites.
///
/// Contains the song ID and the date it was added to favorites.
class FavoriteSong extends Equatable {
  const FavoriteSong({
    required this.id,
    required this.songId,
    required this.dateAdded,
  });

  final int id;
  final int songId;
  final DateTime dateAdded;

  @override
  List<Object> get props => [id, songId, dateAdded];

  FavoriteSong copyWith({
    int? id,
    int? songId,
    DateTime? dateAdded,
  }) {
    return FavoriteSong(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}
