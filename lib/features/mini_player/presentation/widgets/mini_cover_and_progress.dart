import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class MiniCoverAndProgress extends StatelessWidget {
  const MiniCoverAndProgress({
    super.key,
    required this.positionStream,
    required this.durationStream,
    required this.songId,
  });

  final Stream<Duration> positionStream;
  final Stream<Duration?> durationStream;
  final int songId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        QueryArtworkWidget(
          id: songId,
          quality: 50,
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
        SizedBox(
          width: 42,
          height: 42,
          child: StreamBuilder(
            stream: durationStream,
            builder: (context, durationShot) {
              final duration = durationShot.data ?? Duration.zero;
              return StreamBuilder(
                stream: positionStream,
                builder: (context, positionShot) {
                  double value = 0.0;
                  if (positionShot.hasData) {
                    value =
                        (positionShot.data!.inMilliseconds /
                                (duration.inMilliseconds == 0
                                    ? 1
                                    : duration.inMilliseconds))
                            .clamp(0.0, 1.0);
                  }
                  return CircularProgressIndicator(
                    value: value,
                    strokeCap: StrokeCap.round,
                    strokeWidth: 2,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
