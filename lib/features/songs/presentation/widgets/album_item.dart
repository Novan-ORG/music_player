import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class AlbumItem extends StatelessWidget {
  const AlbumItem({required this.album, super.key});

  final Album album;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: ListTile(
        leading: QueryArtworkWidget(id: album.id, type: ArtworkType.ALBUM),
        title: Text(album.album),
        subtitle: Text(album.numOfSongs.toString()),
      ),
    );
  }
}
