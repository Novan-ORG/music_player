import 'package:flutter/material.dart';
import 'package:music_player/extensions/duration_ex.dart';

class AudioProgress extends StatelessWidget {
  const AudioProgress({
    super.key,
    required this.durationStream,
    required this.positionStream,
    this.onSeek,
    this.onChangeEnd,
  });

  final Stream<Duration?> durationStream;
  final Stream<Duration> positionStream;
  final ValueChanged<Duration>? onSeek;
  final ValueChanged<Duration>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: durationStream,
      builder: (context, snapShot) {
        final duration = snapShot.data ?? Duration.zero;
        return Column(
          children: [
            StreamBuilder(
              stream: positionStream,
              builder: (context, snapShot) {
                double value = 0;
                if (snapShot.hasData) {
                  value =
                      (snapShot.data!.inMilliseconds /
                              (duration.inMilliseconds == 0
                                  ? 1
                                  : duration.inMilliseconds))
                          .clamp(0.0, 1.0);
                } else {
                  value = 0.0;
                }
                return Slider(
                  min: 0.0,
                  max: 1.0,
                  padding: EdgeInsets.zero,
                  value: value,
                  onChanged: (value) {
                    final newPosition = Duration(
                      milliseconds: (value * duration.inMilliseconds).round(),
                    );
                    onSeek?.call(newPosition);
                  },
                  onChangeEnd: (value) {
                    final newPosition = Duration(
                      milliseconds: (value * duration.inMilliseconds).round(),
                    );
                    onChangeEnd?.call(newPosition);
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder(
                  stream: positionStream,
                  builder: (context, snapShot) {
                    final position = snapShot.data ?? Duration.zero;
                    return Text(position.format());
                  },
                ),
                Text(duration.format()),
              ],
            ),
          ],
        );
      },
    );
  }
}
