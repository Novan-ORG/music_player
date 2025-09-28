import 'package:flutter/material.dart';

class CountDownTimer extends StatelessWidget {
  const CountDownTimer({
    required this.duration,
    this.onEnd,
    this.fontSize,
    super.key,
  });

  final Duration duration;
  final VoidCallback? onEnd;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Duration>(
      duration: duration,
      tween: Tween(begin: duration, end: Duration.zero),
      onEnd: onEnd,
      builder: (context, value, child) {
        final hours = value.inHours.toString().padLeft(2, '0');
        final minutes = value.inMinutes
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        final seconds = value.inSeconds
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        return Text(
          '$hours:$minutes:$seconds',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: fontSize),
        );
      },
    );
  }
}
