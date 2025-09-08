import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/mini_player/presentation/pages/mini_player_page.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/play_list/presentation/pages/playlists_page.dart';
import 'package:music_player/features/songs/presentation/pages/songs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  late final musicPlayerBloc = context.read<MusicPlayerBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (currentIndex) {
        0 => const SongsPage(),
        1 => const PlaylistsPage(),
        2 => SongsPage(isFavorites: true),
        _ => const SongsPage(),
      },
      bottomSheet: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        bloc: musicPlayerBloc,
        builder: (_, state) {
          if (state.playList.isEmpty) {
            return SizedBox.shrink();
          } else {
            return MiniPlayerPage();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_rounded),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music_rounded),
            label: 'Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
