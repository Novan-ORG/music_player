import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongImageWidget extends StatelessWidget {
  const SongImageWidget({
    required this.songId,
    this.size = 50,
    super.key,
  });

  final int songId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: songId,
      quality: 70,
      type: ArtworkType.AUDIO,
      artworkBorder: BorderRadius.circular(8),
      nullArtworkWidget: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          ImageAssets.songCover,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ),
    );
  }
}
