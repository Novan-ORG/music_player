import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/presentation/pages/playlists_page.dart';
import 'package:music_player/features/search/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/helpers/helpers.dart';
import 'package:music_player/features/songs/presentation/pages/songs_selection_page.dart';
import 'package:music_player/features/songs/presentation/widgets/songs_appbar.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({
    super.key,
  });

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage>
    with
        SongSharingMixin,
        RingtoneMixin,
        PlaylistManagementMixin,
        SongDeletionMixin {
  // Getters for BLoCs
  SongsBloc get _songsBloc => context.read<SongsBloc>();
  MusicPlayerBloc get _musicPlayerBloc => context.read<MusicPlayerBloc>();

  @override
  void initState() {
    super.initState();
  }

  // Event handlers for song actions
  Future<void> _handleSongTap(int songIndex, List<Song> songs) async {
    _musicPlayerBloc.add(PlayMusicEvent(songIndex, songs));
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MusicPlayerPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongsBloc, SongsState>(
      bloc: _songsBloc,
      builder: (context, songsState) {
        return Scaffold(
          appBar: SongsAppbar(
            numOfSongs: songsState.allSongs.length,
            sortType: songsState.sortType,
            onSearchButtonPressed: _onSearchButtonPressed,
            onShuffleAll: () => _onShufflePressed(songsState.allSongs),
            onSortSongs: _onSortSongs,
          ),
          body: BackgroundGradient(
            child: _buildSongsContent(songsState),
          ),
        );
      },
    );
  }

  Future<void> _onSearchButtonPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SearchSongsPage(),
      ),
    );
  }

  Widget _buildSongsContent(SongsState songsState) {
    // Handle loading state
    if (songsState.status == SongsStatus.loading) {
      return const Loading();
    }

    // Handle error state
    if (songsState.status == SongsStatus.error) {
      return SongsErrorLoading(
        message: context.localization.errorLoadingSongs,
        onRetry: () => _songsBloc.add(const LoadSongsEvent()),
      );
    }

    // Handle empty songs
    if (songsState.allSongs.isEmpty) {
      return NoSongsWidget(
        message: context.localization.noSongTryAgain,
        onRefresh: () => _songsBloc.add(const LoadSongsEvent()),
      );
    }

    final songs = songsState.allSongs;

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => _songsBloc.add(const LoadSongsEvent()),
            child:
                BlocSelector<FavoriteSongsBloc, FavoriteSongsState, Set<int>>(
                  selector: (state) {
                    return state.favoriteSongIds;
                  },
                  builder: (context, favoriteSongIds) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: SongsPageConstants.listVerticalPadding,
                        horizontal: SongsPageConstants.listHorizontalPadding,
                      ),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return SongItem(
                          song: song,
                          isLiked: favoriteSongIds.contains(song.id),
                          onSetAsRingtonePressed: () =>
                              setAsRingtone(song.data),
                          onDeletePressed: () => showDeleteSongDialog(song),
                          onToggleLike: () =>
                              context.read<FavoriteSongsBloc>().add(
                                ToggleFavoriteSongEvent(song.id),
                              ),
                          onAddToPlaylistPressed: () async {
                            await PlaylistsPage.showSheet(
                              context: context,
                              songIds: {song.id},
                            );
                          },
                          onSharePressed: () => shareSong(song),
                          onLongPress: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => SongsSelectionPage(
                                title: context.localization.songs,
                                availableSongs: songs,
                                selectedSongIds: {song.id},
                              ),
                            ),
                          ),
                          onTap: () => _handleSongTap(index, songs),
                        );
                      },
                    );
                  },
                ),
          ),
        ),

        // Bottom spacing for mini player
        if (_musicPlayerBloc.state.playList.isNotEmpty)
          const SizedBox(height: SongsPageConstants.minPlayerHeight),
      ],
    );
  }

  void _onShufflePressed(List<Song> songs) {
    _musicPlayerBloc.add(ShuffleMusicEvent(songs: songs));
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MusicPlayerPage(),
      ),
    );
  }

  void _onSortSongs(SortType sortType) {
    _songsBloc.add(SortSongsEvent(sortType));
  }
}
