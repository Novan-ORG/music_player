import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/play_list/presentation/bloc/bloc.dart';
import 'package:music_player/features/play_list/presentation/pages/playlists_page.dart';
import 'package:music_player/features/search/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key, this.playlist, this.isFavorites = false});

  final PlaylistModel? playlist;
  final bool isFavorites;

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  SongsBloc get songsBloc => context.read<SongsBloc>();
  MusicPlayerBloc get musicPlayerBloc => context.read<MusicPlayerBloc>();
  late Set<int>? playlistSongIds = widget.playlist?.songs.toSet();

  Future<void> _setAsRingtone(String songPath) async {
    if (await Permission.systemAlertWindow.request().isGranted) {
      await RingtoneSet.setRingtone(songPath);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.localization.permissionDeniedForRingtone),
        ),
      );
    }
  }

  Future<void> _showDeleteDialog(Song song) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.localization.deleteSong),
        content: Text(context.localization.areSureYouWantToDeleteSong),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.localization.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              songsBloc.add(DeleteSongEvent(song));
              _showUndoSnackbar(song);
            },
            child: Text(context.localization.deleteFromDevice),
          ),
        ],
      ),
    );
  }

  void _showUndoSnackbar(Song song) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${song.title} ${context.localization.deleted}'),
        action: SnackBarAction(
          label: context.localization.undo,
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            songsBloc.add(const UndoDeleteSongEvent());
          },
        ),
        duration: const Duration(seconds: 20),
      ),
    );
  }

  List<Song> _filterSongs(SongsState state, Set<int> likedSongIds) {
    final songs = List<Song>.from(state.allSongs);

    if (playlistSongIds != null) {
      songs.retainWhere((song) => playlistSongIds!.contains(song.id));
    }
    if (widget.isFavorites) {
      songs.retainWhere((song) => likedSongIds.contains(song.id));
    }
    return songs;
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF7F53AC),
      elevation: 0,
      title: Text(
        widget.isFavorites
            ? context.localization.favoriteSongs
            : widget.playlist?.name ?? context.localization.allSongs,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
          letterSpacing: 1.2,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            await Navigator.of(
              context,
            ).push(
              MaterialPageRoute<void>(builder: (_) => const SearchSongsPage()),
            );
          },
          icon: const Icon(Icons.search, size: 28),
          tooltip: context.localization.searchSongs,
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message, VoidCallback onRefresh) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: Text(context.localization.refresh),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongList(List<Song> songs, Set<int> likedSongIds) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return SongItem(
          song: song,
          currentPlaylist: widget.playlist,
          isLiked: likedSongIds.contains(song.id),
          onSetAsRingtonePressed: () => _setAsRingtone(song.uri),
          onDeletePressed: () => _showDeleteDialog(song),
          onToggleLike: () =>
              musicPlayerBloc.add(ToggleLikeMusicEvent(song.id)),
          onAddToPlaylistPressed: () async {
            await PlaylistsPage.showSheet(
              context: context,
              songId: song.id,
            );
          },
          onRemoveFromPlaylistPressed: () {
            if (widget.playlist != null) {
              context.read<PlayListBloc>().add(
                RemoveSongFromPlaylistEvent(song.id, widget.playlist!.id),
              );
              _showRemovedFromPlaylistSnackbar(song);
              setState(() {
                playlistSongIds?.remove(song.id);
              });
            }
          },
          onTap: () async {
            musicPlayerBloc.add(PlayMusicEvent(index, songs));
            await Navigator.of(
              context,
            ).push(
              MaterialPageRoute<void>(
                builder: (_) => BlocProvider.value(
                  value: musicPlayerBloc,
                  child: const MusicPlayerPage(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showRemovedFromPlaylistSnackbar(Song song) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${song.title} removed from ${widget.playlist?.name ?? "playlist"}',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(
            MaterialPageRoute<void>(builder: (_) => const SearchSongsPage()),
          );
        },
        tooltip: context.localization.searchSongs,
        child: const Icon(Icons.search, size: 28, color: Colors.white),
      ),
      body: BackgroundGradient(
        child: BlocBuilder<SongsBloc, SongsState>(
          bloc: songsBloc,
          builder: (context, state) {
            if (state.status == SongsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == SongsStatus.error) {
              return _buildEmptyState(
                context.localization.errorLoadingSongs,
                () {
                  songsBloc.add(const LoadSongsEvent());
                },
              );
            }
            if (state.allSongs.isEmpty) {
              return _buildEmptyState(
                context.localization.noSongTryAgain,
                () => songsBloc.add(const LoadSongsEvent()),
              );
            }
            return BlocSelector<MusicPlayerBloc, MusicPlayerState, Set<int>>(
              bloc: musicPlayerBloc,
              selector: (state) => state.likedSongIds,
              builder: (context, likedSongIds) {
                final filteredSongs = _filterSongs(state, likedSongIds);

                if (filteredSongs.isEmpty) {
                  return _buildEmptyState(
                    widget.isFavorites
                        ? context.localization.noSongTryAgain
                        : context.localization.noSongInPlaylist,
                    () => songsBloc.add(const LoadSongsEvent()),
                  );
                }

                return Column(
                  children: [
                    TopHeadActions(
                      songCount: filteredSongs.length,
                      onShuffleAll: () async {
                        musicPlayerBloc.add(
                          ShuffleMusicEvent(songs: filteredSongs),
                        );
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const MusicPlayerPage(),
                          ),
                        );
                      },
                      onSortSongs: (sortType) {
                        songsBloc.add(SortSongsEvent(sortType));
                      },
                      sortType: state.sortType,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async =>
                            songsBloc.add(const LoadSongsEvent()),
                        child: _buildSongList(filteredSongs, likedSongIds),
                      ),
                    ),
                    if (musicPlayerBloc.state.playList.isNotEmpty)
                      const SizedBox(height: 80),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
