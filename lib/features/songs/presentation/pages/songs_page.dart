import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/search/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/views/views.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

/// Main songs library page with tabs for songs, albums, and artists.
class SongsPage extends StatefulWidget {
  const SongsPage({
    super.key,
  });

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    pageController = PageController();

    scheduleMicrotask(() {
      if (!mounted) return;
      context.read<AlbumsBloc>().add(const LoadAlbumsEvent());
      context.read<ArtistsBloc>().add(const LoadArtistsEvent());
    });
  }

  void animateToNewPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  void _refreshDerivedLibraries() {
    final albumsBloc = context.read<AlbumsBloc>();
    final artistsBloc = context.read<ArtistsBloc>();

    albumsBloc.add(
      LoadAlbumsEvent(sortType: albumsBloc.state.sortType),
    );
    artistsBloc.add(
      LoadArtistsEvent(sortType: artistsBloc.state.sortType),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final useWideLayout =
            constraints.maxWidth >= 700 && constraints.maxHeight < 620;
        final preferredSideWidth = constraints.maxWidth * 0.36;
        final sideWidth = preferredSideWidth < 320
            ? 320.0
            : preferredSideWidth > 430
            ? 430.0
            : preferredSideWidth;
        final pageView = PageView(
          controller: pageController,
          onPageChanged: tabController.animateTo,
          children: const [
            AllSongsView(),
            AlbumsView(),
            ArtistsView(),
          ],
        );

        return BlocListener<SongsBloc, SongsState>(
          listenWhen: (previous, current) =>
              previous.allSongs != current.allSongs &&
              current.status == SongsStatus.loaded,
          listener: (_, state) => _refreshDerivedLibraries(),
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.24),
                    const Color(0xFF00BFA6).withValues(alpha: 0.1),
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor,
                  ],
                  stops: const [0, 0.22, 0.5, 1],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: useWideLayout
                    ? Row(
                        children: [
                          SizedBox(
                            width: sideWidth,
                            child: Column(
                              children: [
                                LibraryHeader(
                                  compact: true,
                                  onSearchPressed: _onSearchButtonPressed,
                                  onStartMixPressed: _onStartMixPressed,
                                ),
                                CategoryTabbar(
                                  tabController: tabController,
                                  onTabChanged: animateToNewPage,
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: pageView),
                        ],
                      )
                    : Column(
                        children: [
                          LibraryHeader(
                            onSearchPressed: _onSearchButtonPressed,
                            onStartMixPressed: _onStartMixPressed,
                          ),
                          CategoryTabbar(
                            tabController: tabController,
                            onTabChanged: animateToNewPage,
                          ),
                          Expanded(child: pageView),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onStartMixPressed() async {
    final songs = context.read<SongsBloc>().state.allSongs;
    if (songs.isEmpty) return;

    context.read<MusicPlayerBloc>().add(ShuffleMusicEvent(songs: songs));
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MusicPlayerPage(enableArtworkHero: false),
      ),
    );
  }

  Future<void> _onSearchButtonPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SearchSongsPage(),
      ),
    );
  }
}
