import 'package:flutter/material.dart';

typedef CountDownTimerBuilder =
    Widget Function(BuildContext context, Duration value);

class CountDownTimer extends StatelessWidget {
  const CountDownTimer({
    required this.duration,
    this.onEnd,
    this.fontSize,
    this.style,
    this.textAlign,
    this.builder,
    this.forceLtr = false,
    super.key,
  });

  final Duration duration;
  final VoidCallback? onEnd;
  final double? fontSize;
  final TextStyle? style;
  final TextAlign? textAlign;
  final CountDownTimerBuilder? builder;
  final bool forceLtr;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Duration>(
      duration: duration,
      tween: Tween(begin: duration, end: Duration.zero),
      onEnd: onEnd,
      builder: (context, value, child) {
        if (builder != null) {
          return builder!(context, value);
        }

        final hours = value.inHours.toString().padLeft(2, '0');
        final minutes = value.inMinutes
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        final seconds = value.inSeconds
            .remainder(60)
            .toString()
            .padLeft(2, '0');

        return Directionality(
          textDirection: forceLtr
              ? TextDirection.ltr
              : Directionality.of(context),
          child: Text(
            '$hours:$minutes:$seconds',
            textAlign: textAlign,
            style:
                style ??
                Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: fontSize,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        );
      },
    );
  }
}
