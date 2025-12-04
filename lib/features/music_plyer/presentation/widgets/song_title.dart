import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class SongTitle extends StatelessWidget {
  const SongTitle({super.key, this.songTitle});
  final String? songTitle;

  @override
  Widget build(BuildContext context) {
    final title = songTitle ?? 'Unknown Song';
    return AutoSizeText(
      title,
      minFontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 14,
      style: Theme.of(context).textTheme.titleLarge,
      maxLines: 1,
      overflowReplacement: SizedBox(
        height: 22,
        child: Marquee(
          text: title,
          style: Theme.of(context).textTheme.titleLarge,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 30,
          velocity: 40,
          pauseAfterRound: const Duration(seconds: 1),
          accelerationDuration: const Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: const Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        ),
      ),
    );
  }
}
