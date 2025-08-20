import 'package:flutter/material.dart';
import 'package:music_player/features/mini_player/presentation/widgets/mini_cover_and_progress.dart';

class MiniPlayerPage extends StatelessWidget {
  const MiniPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: MiniCoverAndProgress(position: Stream.empty(), songId: 1),
        // title: Text(songName, style: Theme.of(context).textTheme.bodyMedium),
        // subtitle: Text(
        //   songArtist,
        //   style: Theme.of(context).textTheme.bodySmall,
        // ),
        trailing: Row(
          spacing: 4,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
            const SizedBox(width: 2),
            IconButton(onPressed: () {}, icon: Icon(Icons.skip_previous)),
            IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
            IconButton(onPressed: () {}, icon: Icon(Icons.skip_next)),
          ],
        ),
      ),
    );
  }
}
