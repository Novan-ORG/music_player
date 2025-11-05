import 'package:equatable/equatable.dart';

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
