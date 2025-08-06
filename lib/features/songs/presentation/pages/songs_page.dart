import 'package:flutter/material.dart';
import 'package:music_player/features/songs/presentation/widgets/song_item.dart';

class SongsPage extends StatelessWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Songs Page')),
      body: ListView.builder(
        itemCount: 25,
        itemBuilder: (_, index) {
          return const SongItem();
        },
      ),
    );
  }
}
