import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/extensions/extensions.dart';

class SongTitle extends StatelessWidget {
  const SongTitle({super.key, this.songTitle});
  final String? songTitle;

  @override
  Widget build(BuildContext context) {
    final title = songTitle ?? context.localization.unknownSong;
    final baseStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      height: 1.2,
    );
    final baseFontSize = baseStyle?.fontSize ?? 22;
    final titleHeight = baseFontSize * 1.3;

    return AutoSizeText(
      title,
      minFontSize: baseFontSize > 16 ? baseFontSize - 4 : baseFontSize,
      style: baseStyle,
      strutStyle: StrutStyle(
        fontSize: baseFontSize,
        height: 1.2,
        forceStrutHeight: true,
      ),
      maxLines: 1,
      overflowReplacement: SizedBox(
        height: titleHeight,
        child: Marquee(
          text: title,
          style: baseStyle,
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
