import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

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
    final theme = context.theme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      height: 20,
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
              return LayoutBuilder(
                builder: (context, constraints) {
                  final trackWidth = constraints.maxWidth - 20;
                  final thumbStart = (trackWidth * value).clamp(
                    0.0,
                    trackWidth,
                  );

                  void seekFromLocalPosition(Offset localPosition) {
                    if (duration.inMilliseconds == 0) return;
                    final tappedValue =
                        (localPosition.dx / constraints.maxWidth).clamp(
                          0.0,
                          1.0,
                        );
                    final newValue = isRtl ? 1 - tappedValue : tappedValue;
                    onSeek?.call(
                      Duration(
                        milliseconds: (newValue * duration.inMilliseconds)
                            .round(),
                      ),
                    );
                  }

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) =>
                        seekFromLocalPosition(details.localPosition),
                    onHorizontalDragUpdate: (details) =>
                        seekFromLocalPosition(details.localPosition),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.dividerColor.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: value,
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    const Color(0xFF00BFA6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(99),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.24,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            start: thumbStart,
                            child: Transform.translate(
                              offset: Offset(isRtl ? 6 : -6, 0),
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary,
                                  border: Border.all(
                                    color: theme.colorScheme.surface,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.38),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
