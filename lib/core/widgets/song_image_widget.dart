import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongImageWidget extends StatelessWidget {
  const SongImageWidget({
    required this.songId,
    this.size = 50,
    this.quality = 70,
    this.qualitySize = 200,
    this.artworkQuality = FilterQuality.medium,
    this.borderRadius,
    this.artworkFit = BoxFit.cover,
    this.defaultCover = ImageAssets.songCover,
    super.key,
  });

  final int songId;
  final double size;
  final double? borderRadius;
  final int quality;
  final int qualitySize;
  final FilterQuality artworkQuality;
  final BoxFit artworkFit;
  final String defaultCover;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: songId,
      quality: quality,
      type: ArtworkType.AUDIO,
      size: qualitySize,
      artworkWidth: size,
      artworkHeight: size,
      artworkQuality: artworkQuality,
      artworkFit: artworkFit,
      // I used the size for radius to make it circular by default
      artworkBorder: BorderRadius.circular(borderRadius ?? (size / 2)),
      nullArtworkWidget: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? (size / 2)),
        child: ColoredBox(
          color: Colors.white,
          child: Image.asset(
            defaultCover,
            fit: BoxFit.cover,
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}
