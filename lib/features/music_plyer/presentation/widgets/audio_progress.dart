import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:wave_player/wave_player.dart';

class AudioProgress extends StatelessWidget {
  const AudioProgress({
    required this.durationStream,
    required this.positionStream,
    required this.waveformData,
    this.onSeek,
    super.key,
  });

  final Stream<Duration?> durationStream;
  final Stream<Duration> positionStream;
  final ValueChanged<Duration>? onSeek;
  final List<double> waveformData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: durationStream,
      builder: (context, snapShot) {
        final duration = snapShot.data ?? Duration.zero;
        return Column(
          spacing: 8,
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

                return BasicAudioSlider(
                  value: value,
                  activeColor: context.theme.primaryColor,
                  height: 38,
                  max: 1,
                  barSpacing: 2,
                  barWidth: 3,
                  thumbShape: ThumbShape.verticalBar,
                  thumbColor: context.theme.colorScheme.onPrimary,
                  onChanged: (value) {
                    final newPosition = Duration(
                      milliseconds: (value * duration.inMilliseconds).round(),
                    );
                    onSeek?.call(newPosition);
                  },
                  onChangeStart: () {},
                  onChangeEnd: () {},
                  waveformData: waveformData,
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
