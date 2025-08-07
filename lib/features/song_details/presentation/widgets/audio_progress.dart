import 'package:flutter/material.dart';

class AudioProgress extends StatelessWidget {
  const AudioProgress({
    super.key,
    required this.progress,
    required this.duration,
    required this.position,
    this.onSeek,
    this.onChangeEnd,
    this.onChangeStart,
  });

  final double progress;
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration>? onSeek;
  final ValueChanged<Duration>? onChangeEnd;
  final ValueChanged<Duration>? onChangeStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: progress,
          onChanged: (value) {
            final newPosition = Duration(
              milliseconds: (value * duration.inMilliseconds).round(),
            );
            onSeek?.call(newPosition);
            onChangeStart?.call(newPosition);
          },
          onChangeEnd: (value) {
            final newPosition = Duration(
              milliseconds: (value * duration.inMilliseconds).round(),
            );
            onChangeEnd?.call(newPosition);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(position.toString().split('.').first),
            Text(duration.toString().split('.').first),
          ],
        ),
      ],
    );
  }
}
