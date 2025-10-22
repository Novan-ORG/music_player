import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class PlaylistModel extends Equatable {
  @Id(assignable: true)
  final int id;
  final String name;
  final String? imagePath;
  final String? description;
  final List<int> songs;

  const PlaylistModel({
    required this.id,
    required this.name,
    this.songs = const [],
    this.imagePath,
    this.description,
  });

  PlaylistModel copyWith({
    int? id,
    String? name,
    List<int>? songs,
    String? description,
    String? imagePath,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      songs: songs ?? this.songs,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [id, name, songs, description, imagePath];
}
