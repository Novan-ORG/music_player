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
import 'package:share_plus/share_plus.dart';

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

  Future<void> _shareSongs(List<Song> songs) async {
    if (songs.length == 1) {
      await _shareSong(songs.first);
    } else {
      // Share multiple songs as text list
      final songList = songs
          .map((song) => '${song.title} - ${song.artist}')
          .join('\n');
      final result = await SharePlus.instance.share(
        ShareParams(
          text: context.localization.shareSongsSubject(songs.length, songList),
          files: songs.map((song) => XFile(song.uri)).toList(),
        ),
      );
      if (result.status == ShareResultStatus.success) {
        songsBloc.add(const ClearSelectionEvent());
      }
    }
  }

  Future<void> _shareSong(Song song) async {
    await SharePlus.instance.share(
      ShareParams(
        text: song.title,
        subject: song.artist,
        files: [XFile(song.uri)],
      ),
    );
  }

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

  Future<void> _showDeleteSelectedDialog(List<Song> songs) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.localization.deleteSongsAlertTitle(songs.length)),
        content: Text(
          context.localization.deleteSongsAlertContent,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.localization.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              songsBloc.add(const DeleteSelectedSongsEvent());
              _showDeletedSnackbar(songs.length);
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

  void _showDeletedSnackbar(int count) {
    final songLocalized = count > 1
        ? context.localization.songs
        : context.localization.song;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$count $songLocalized ${context.localization.deleted}',
        ),
        duration: const Duration(seconds: 3),
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

  PreferredSize _buildAppBar(
    BuildContext context,
    SongsState state,
  ) {
    if (state.isSelectionMode) {
      final filteredSongs = _filterSongs(
        state,
        musicPlayerBloc.state.likedSongIds,
      );
      return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: _buildSelectionActionBar(state, filteredSongs),
        ),
      );
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
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
                MaterialPageRoute<void>(
                  builder: (_) => const SearchSongsPage(),
                ),
              );
            },
            tooltip: context.localization.searchSongs,
            icon: const Icon(Icons.search, size: 28, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, VoidCallback onRefresh) {
    return NoSongsWidget(message: message, onRefresh: onRefresh);
  }

  Widget _buildSongList(
    List<Song> songs,
    Set<int> likedSongIds,
    SongsState songsState,
  ) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        final isSelected = songsState.selectedSongIds.contains(song.id);

        return SongItem(
          song: song,
          currentPlaylist: widget.playlist,
          isLiked: likedSongIds.contains(song.id),
          isSelected: isSelected,
          isSelectionMode: songsState.isSelectionMode,
          onSetAsRingtonePressed: () => _setAsRingtone(song.uri),
          onDeletePressed: () => _showDeleteDialog(song),
          onToggleLike: () =>
              musicPlayerBloc.add(ToggleLikeMusicEvent(song.id)),
          onAddToPlaylistPressed: () async {
            await PlaylistsPage.showSheet(
              context: context,
              songIds: {song.id},
            );
          },
          onSharePressed: () => _shareSong(song),
          onRemoveFromPlaylistPressed: () {
            if (widget.playlist != null) {
              context.read<PlayListBloc>().add(
                RemoveSongsFromPlaylistEvent({song.id}, widget.playlist!.id),
              );
              _showRemovedFromPlaylistSnackbar(song);
              setState(() {
                playlistSongIds?.remove(song.id);
              });
            }
          },
          onSelectionChanged: (selected) {
            if (selected ?? false) {
              songsBloc.add(SelectSongEvent(song.id));
            } else {
              songsBloc.add(DeselectSongEvent(song.id));
            }
          },
          onLongPress: () {
            if (!songsState.isSelectionMode) {
              songsBloc
                ..add(const ToggleSelectionModeEvent())
                ..add(SelectSongEvent(song.id));
            }
          },
          onTap: () async {
            if (songsState.isSelectionMode) return;

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
    return BlocBuilder<SongsBloc, SongsState>(
      bloc: songsBloc,
      builder: (context, songsState) {
        return Scaffold(
          appBar: _buildAppBar(context, songsState),
          floatingActionButton: !songsState.isSelectionMode
              ? FloatingActionButton(
                  onPressed: () async {
                    await Navigator.of(
                      context,
                    ).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SearchSongsPage(),
                      ),
                    );
                  },
                  tooltip: context.localization.searchSongs,
                  child: const Icon(
                    Icons.search,
                    size: 28,
                    color: Colors.white,
                  ),
                )
              : null,
          body: BackgroundGradient(
            child: _buildSongsContent(songsState),
          ),
        );
      },
    );
  }

  Widget _buildSongsContent(SongsState songsState) {
    if (songsState.status == SongsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (songsState.status == SongsStatus.error) {
      return _buildEmptyState(
        context.localization.errorLoadingSongs,
        () {
          songsBloc.add(const LoadSongsEvent());
        },
      );
    }
    if (songsState.allSongs.isEmpty) {
      return _buildEmptyState(
        context.localization.noSongTryAgain,
        () => songsBloc.add(const LoadSongsEvent()),
      );
    }

    return BlocSelector<MusicPlayerBloc, MusicPlayerState, Set<int>>(
      bloc: musicPlayerBloc,
      selector: (state) => state.likedSongIds,
      builder: (context, likedSongIds) {
        final filteredSongs = _filterSongs(songsState, likedSongIds);

        if (filteredSongs.isEmpty) {
          return _buildEmptyState(
            widget.isFavorites
                ? context.localization.noFavoriteSong
                : context.localization.noSongInPlaylist,
            () => songsBloc.add(const LoadSongsEvent()),
          );
        }

        return Column(
          children: [
            if (!songsState.isSelectionMode)
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
                sortType: songsState.sortType,
              ),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => songsBloc.add(const LoadSongsEvent()),
                child: _buildSongList(filteredSongs, likedSongIds, songsState),
              ),
            ),
            if (musicPlayerBloc.state.playList.isNotEmpty)
              const SizedBox(height: 80),
          ],
        );
      },
    );
  }

  Widget _buildSelectionActionBar(
    SongsState songsState,
    List<Song> filteredSongs,
  ) {
    final selectedSongs = songsState.allSongs
        .where((song) => songsState.selectedSongIds.contains(song.id))
        .toList();

    return SelectionActionBar(
      selectedCount: songsState.selectedSongIds.length,
      totalCount: filteredSongs.length,
      isInPlaylist: widget.playlist != null,
      onAddToPlaylist: () async {
        await PlaylistsPage.showSheet(
          context: context,
          songIds: selectedSongs.map((song) => song.id).toSet(),
        );
        songsBloc.add(const ClearSelectionEvent());
      },
      onRemoveFromPlaylist: () {
        if (widget.playlist == null) return;
        // Remove selected songs from the current playlist
        context.read<PlayListBloc>().add(
          RemoveSongsFromPlaylistEvent(
            selectedSongs.map((song) => song.id).toSet(),
            widget.playlist!.id,
          ),
        );
        // Update the local playlist song IDs
        setState(() {
          playlistSongIds?.removeAll(selectedSongs.map((s) => s.id));
        });
        // Show feedback and clear selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${selectedSongs.length} ${context.localization.song}'
              '${selectedSongs.length > 1 ? context.localization.s : ''} '
              '${context.localization.removeFromPlaylist}:'
              ' ${widget.playlist!.name}',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        songsBloc.add(const ClearSelectionEvent());
      },
      onDelete: () => _showDeleteSelectedDialog(selectedSongs),
      onShare: () => _shareSongs(selectedSongs),
      onSelectAll: () => songsBloc.add(SelectAllSongsEvent(filteredSongs)),
      onDeselectAll: () => songsBloc.add(const SelectAllSongsEvent([])),
      onClearSelection: () => songsBloc.add(const ClearSelectionEvent()),
    );
  }
}
