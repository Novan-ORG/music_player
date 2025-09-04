import 'package:objectbox/objectbox.dart';

@Entity()
class PlaylistModel {
  @Id()
  int id;
  final String name;
  final String? imagePath;
  final String? description;

  PlaylistModel({
    this.id = 0,
    required this.name,
    this.imagePath,
    this.description,
  });
}
