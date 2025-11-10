import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongImageWidget extends StatelessWidget {
  const SongImageWidget({
    required this.songId,
    this.size = 50,
    this.borderRadius,
    super.key,
  });

  final int songId;
  final double size;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: songId,
      quality: 70,
      type: ArtworkType.AUDIO,
      // I used the size for radius to make it circular by default
      artworkBorder: BorderRadius.circular(borderRadius ?? size),
      nullArtworkWidget: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? size),
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
