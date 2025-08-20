import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class MiniCoverAndProgress extends StatelessWidget {
  const MiniCoverAndProgress({
    super.key,
    required this.position,
    required this.songId,
  });

  final Stream<Duration> position;
  final int songId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        QueryArtworkWidget(
          id: songId,
          quality: 70,
          type: ArtworkType.AUDIO,
          artworkBorder: BorderRadius.circular(38.0),
          artworkWidth: 38,
          artworkHeight: 38,
          nullArtworkWidget: ClipRRect(
            borderRadius: BorderRadius.circular(38.0),
            child: Image.asset(
              'assets/images/song_cover.png',
              fit: BoxFit.cover,
              width: 38,
              height: 38,
              alignment: Alignment.center,
            ),
          ),
        ),
        CircularProgressIndicator(value: 0.3,),
      ],
    );
  }
}
