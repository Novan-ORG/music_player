import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart'
    show SongModel, QueryArtworkWidget, ArtworkType;

class SongArtwork extends StatelessWidget {
  final SongModel? song;
  const SongArtwork({super.key, this.song});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * 0.33;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: song != null
              ? QueryArtworkWidget(
                  id: song!.id,
                  type: ArtworkType.AUDIO,
                  quality: 100,
                  artworkFit: BoxFit.cover,
                  artworkQuality: FilterQuality.high,
                  artworkBorder: BorderRadius.circular(16.0),
                  artworkWidth: size,
                  artworkHeight: size,
                  nullArtworkWidget: Image.asset(
                    'assets/images/song_cover.png',
                    fit: BoxFit.cover,
                    width: size,
                    height: size,
                    alignment: Alignment.center,
                  ),
                )
              : Image.asset(
                  'assets/images/song_cover.png',
                  fit: BoxFit.cover,
                  width: size,
                  height: size,
                  alignment: Alignment.center,
                ),
        ),
      ),
    );
  }
}
