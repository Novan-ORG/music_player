import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class MiniCoverAndProgress extends StatelessWidget {
  const MiniCoverAndProgress({
    required this.positionStream,
    required this.durationStream,
    required this.songId,
    super.key,
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
          type: ArtworkType.AUDIO,
          artworkBorder: BorderRadius.circular(46),
          artworkWidth: 46,
          artworkHeight: 46,
          nullArtworkWidget: ClipRRect(
            borderRadius: BorderRadius.circular(46),
            child: Image.asset(
              ImageAssets.songCover,
              fit: BoxFit.cover,
              width: 46,
              height: 46,
            ),
          ),
        ),
        SizedBox(
          width: 48,
          height: 48,
          child: StreamBuilder(
            stream: durationStream,
            builder: (context, durationShot) {
              final duration = durationShot.data ?? Duration.zero;
              return StreamBuilder(
                stream: positionStream,
                builder: (context, positionShot) {
                  double value = 0;
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
                    strokeWidth: 4,
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
