import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongImageWidget extends StatelessWidget {
  const SongImageWidget({super.key, required this.songId, this.size = 50});

  final int songId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: songId,
      quality: 70,
      type: ArtworkType.AUDIO,
      artworkBorder: BorderRadius.circular(8.0),
      nullArtworkWidget: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          'assets/images/song_cover.png',
          fit: BoxFit.cover,
          width: size,
          height: size,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
