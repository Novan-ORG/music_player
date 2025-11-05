import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/pages/pages.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/presentation/pages/pages.dart';
import 'package:music_player/features/settings/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/pages/pages.dart';

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
    FavoriteSongsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navBarItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.music_note_rounded),
        label: context.localization.songs,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.queue_music_rounded),
        label: context.localization.playlists,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.favorite_rounded),
        label: context.localization.favorites,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings_rounded),
        label: context.localization.settings,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        bloc: _musicPlayerBloc,
        builder: (_, state) {
          if (state.playList.isEmpty) {
            return const SizedBox.shrink();
          } else {
            return const MiniPlayerPage();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: navBarItems,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.disabledColor,
        showUnselectedLabels: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
