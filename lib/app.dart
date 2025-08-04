// App router, theme, etc.

import 'package:flutter/material.dart';
import 'package:music_player/features/songs/presentation/pages/songs_page.dart';

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SongsPage(),
    );
  }
}
