import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/pages/pages.dart';
import 'package:music_player/features/home/presentation/widgets/widgets.dart';
import 'package:music_player/features/playlist/presentation/pages/pages.dart';
import 'package:music_player/features/settings/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/pages/pages.dart';

/// Main home page with bottom navigation and mini player.
///
/// Navigation tabs:
/// - Songs library (songs, albums, artists)
/// - Playlists
/// - Favorite songs
/// - Settings
/// - Mini player at bottom
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    SongsPage(),
    PlaylistsPage(),
    FavoriteSongsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final navItems = _navItems(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final useSideNavigation =
            constraints.maxWidth >= 700 && constraints.maxHeight < 620;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: useSideNavigation
              ? Row(
                  children: [
                    HomeSideNavRail(
                      items: navItems,
                      currentIndex: _currentIndex,
                      onChanged: _onNavChanged,
                    ),
                    Expanded(child: HomeBody(_pages[_currentIndex])),
                  ],
                )
              : HomeBody(_pages[_currentIndex]),
          bottomNavigationBar: useSideNavigation
              ? null
              : HomeBottomNavDock(
                  items: navItems,
                  currentIndex: _currentIndex,
                  onChanged: _onNavChanged,
                ),
        );
      },
    );
  }

  void _onNavChanged(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  List<HomeNavItem> _navItems(BuildContext context) {
    return [
      HomeNavItem(
        icon: const Icon(Icons.music_note_rounded),
        label: context.localization.songs,
      ),
      HomeNavItem(
        icon: const Icon(Icons.library_music),
        label: context.localization.playlists,
      ),
      HomeNavItem(
        icon: const Icon(Icons.favorite_rounded),
        label: context.localization.favorites,
      ),
      HomeNavItem(
        icon: const Icon(Icons.settings_rounded),
        label: context.localization.settings,
      ),
    ];
  }
}
