import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart'
    show ArtworkType, QueryArtworkWidget;

class SongArtwork extends StatelessWidget {
  const SongArtwork({super.key, this.song});
  final Song? song;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * 0.33;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: song != null
              ? QueryArtworkWidget(
                  id: song!.id,
                  type: ArtworkType.AUDIO,
                  quality: 100,
                  artworkQuality: FilterQuality.high,
                  artworkBorder: BorderRadius.circular(16),
                  artworkWidth: size,
                  artworkHeight: size,
                  nullArtworkWidget: Image.asset(
                    ImageAssets.songCover,
                    fit: BoxFit.cover,
                    width: size,
                    height: size,
                  ),
                )
              : Image.asset(
                  ImageAssets.songCover,
                  fit: BoxFit.cover,
                  width: size,
                  height: size,
                ),
        ),
      ),
    );
  }
}
