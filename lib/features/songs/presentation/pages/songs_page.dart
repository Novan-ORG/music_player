import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/domain/enums/enums.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/presentation/pages/playlists_page.dart';
import 'package:music_player/features/search/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/constants/constants.dart';
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
        SongDeletionMixin,
        ToggleLikeMixin {
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
            onSearchButtonPressed: _onSearchButtonPressed,
          ),
          body: _buildSongsContent(songsState),
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

  Future<void> onLongPress(Song song, List<Song> songs) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SongsSelectionPage(
          title: context.localization.songs,
          availableSongs: songs,
          selectedSongIds: {song.id},
        ),
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

    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      bloc: context.read<MusicPlayerBloc>(),
      buildWhen: (previous, next) =>
          previous.currentSongIndex != next.currentSongIndex ||
          previous.playList != next.playList ||
          previous.status != next.status,
      builder: (context, musicPlayerState) {
        return Column(
          children: [
            SortTypeRuler(
              currentSortType: songsState.sortType,
              onSortTypeChanged: _onSortSongs,
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _songsBloc.add(const LoadSongsEvent()),
                child:
                    BlocSelector<
                      FavoriteSongsBloc,
                      FavoriteSongsState,
                      Set<int>
                    >(
                      selector: (state) {
                        return state.favoriteSongIds;
                      },
                      builder: (context, favoriteSongIds) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            vertical: SongsPageConstants.listVerticalPadding,
                            horizontal:
                                SongsPageConstants.listHorizontalPadding,
                          ),
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            final isCurrent =
                                musicPlayerState.currentSong?.id == song.id;
                            return SongItem(
                              track: song,
                              isCurrentTrack: isCurrent,
                              isPlayingNow:
                                  musicPlayerState.status ==
                                      MusicPlayerStatus.playing &&
                                  isCurrent,
                              isFavorite: favoriteSongIds.contains(song.id),
                              onSetAsRingtone: () => setAsRingtone(song.data),
                              onDelete: () => showDeleteSongDialog(song),
                              onFavoriteToggle: () => onToggleLike(song.id),
                              onAddToPlaylist: () async {
                                await PlaylistsPage.showSheet(
                                  context: context,
                                  songIds: {song.id},
                                );
                              },
                              onShare: () => shareSong(song),
                              onLongPress: () => onLongPress(song, songs),
                              onTap: () => _handleSongTap(index, songs),
                              onPlayPause: () {
                                context.read<MusicPlayerBloc>().add(
                                  const TogglePlayPauseEvent(),
                                );
                              },
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
      },
    );
  }

  void _onSortSongs(SongsSortType sortType) {
    _songsBloc.add(SortSongsEvent(sortType));
  }
}
