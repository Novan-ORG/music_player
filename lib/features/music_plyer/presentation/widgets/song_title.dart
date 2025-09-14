import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' show SongModel;

class SongTitle extends StatelessWidget {
  final SongModel? song;
  const SongTitle({super.key, this.song});

  @override
  Widget build(BuildContext context) {
    final title = song?.displayNameWOExt ?? 'Unknown Song';
    return AutoSizeText(
      title,
      style: Theme.of(context).textTheme.titleLarge,
      maxLines: 1,
      overflowReplacement: SizedBox(
        height: 22,
        child: Marquee(
          text: title,
          style: Theme.of(context).textTheme.titleLarge,
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 30.0,
          showFadingOnlyWhenScrolling: true,
          velocity: 40.0,
          pauseAfterRound: Duration(seconds: 1),
          accelerationDuration: Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        ),
      ),
    );
  }
}
