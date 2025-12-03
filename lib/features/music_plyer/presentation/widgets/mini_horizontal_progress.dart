import 'package:flutter/material.dart';

class MiniHorizontalProgress extends StatelessWidget {
  const MiniHorizontalProgress({
    required this.positionStream,
    required this.durationStream,
    this.onSeek,
    super.key,
  });

  final Stream<Duration> positionStream;
  final Stream<Duration?> durationStream;
  final ValueChanged<Duration>? onSeek;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              return Slider(
                value: value,
                padding: EdgeInsets.zero,
                divisions: 100,
                onChanged: (newValue) {
                  final newPosition = Duration(
                    milliseconds: (newValue * duration.inMilliseconds).round(),
                  );
                  onSeek?.call(newPosition);
                },
              );
            },
          );
        },
      ),
    );
  }
}
