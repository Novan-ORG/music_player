import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/mini_player/presentation/pages/mini_player_page.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/play_list/presentation/pages/playlists_page.dart';
import 'package:music_player/features/settings/presentation/pages/settings_page.dart';
import 'package:music_player/features/songs/presentation/pages/songs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final MusicPlayerBloc _musicPlayerBloc = context.read<MusicPlayerBloc>();

  final List<Widget> _pages = const [
    SongsPage(),
    PlaylistsPage(),
    SongsPage(isFavorites: true),
    SettingsPage(),
  ];

  final List<BottomNavigationBarItem> _navBarItems = const [
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
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_rounded),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomSheet: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        bloc: _musicPlayerBloc,
        builder: (_, state) {
          if (state.playList.isEmpty) {
            return const SizedBox.shrink();
          }
          return const MiniPlayerPage();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navBarItems,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.disabledColor,
        showUnselectedLabels: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
