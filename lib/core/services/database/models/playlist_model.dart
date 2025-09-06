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

  @override
  List<Object?> get props => [id, name, songs, description, imagePath];
}
