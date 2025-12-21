import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class ArtImageWidget extends StatelessWidget {
  const ArtImageWidget({
    required this.id,
    this.type = ArtworkType.AUDIO,
    this.size = 54,
    this.quality = 70,
    this.qualitySize = 200,
    this.defaultCoverBg,
    this.artworkQuality = FilterQuality.medium,
    this.borderRadius,
    this.artworkFit = BoxFit.cover,
    this.defaultCover = ImageAssets.songCover,
    super.key,
  });

  final int id;
  final ArtworkType type;
  final double size;
  final double? borderRadius;
  final int quality;
  final int qualitySize;
  final FilterQuality artworkQuality;
  final BoxFit artworkFit;
  final String defaultCover;
  final Color? defaultCoverBg;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: id,
      quality: quality,
      type: type,
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
          color: defaultCoverBg ?? context.theme.scaffoldBackgroundColor,
          child: Image.asset(
            defaultCover,
            fit: artworkFit,
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}
