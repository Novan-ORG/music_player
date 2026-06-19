import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/playlist.dart';
import 'package:music_player/features/songs/presentation/bloc/songs_bloc.dart';
import 'package:music_player/features/songs/presentation/pages/add_songs_page.dart';

/// Mixin that provides playlist management functionality
mixin PlaylistManagementMixin<T extends StatefulWidget> on State<T> {
  /// Add songs to a playlist
  Future<Set<int>?> addSongsToPlaylist(
    Playlist playlist,
    Set<int>? currentSongIds,
  ) async {
    final selectedSongIds = await Navigator.of(context).push<Set<int>>(
      MaterialPageRoute<Set<int>>(
        builder: (_) => AddSongsPage(
          listName: playlist.name,
          availableSongs: _availableSongs(
            currentSongIdsToExclude: currentSongIds,
          ),
        ),
      ),
    );

    if (selectedSongIds != null && selectedSongIds.isNotEmpty && mounted) {
      final playlistBloc = context.read<PlayListBloc>();
      final completion = playlistBloc.stream.firstWhere(
        (state) =>
            state.status == PlayListStatus.loaded ||
            state.status == PlayListStatus.error,
      );
      playlistBloc.add(
        AddSongsToPlaylistsEvent(
          selectedSongIds,
          [playlist.id],
        ),
      );
      final result = await completion;

      if (mounted && result.status == PlayListStatus.loaded) {
        _showSongsAddedMessage(selectedSongIds.length, playlist.name);
      } else if (mounted) {
        AppSnackBar.showError(
          context,
          title: context.localization.error,
          message: result.errorMessage ?? context.localization.playlistPage,
        );
      }
    }

    return selectedSongIds;
  }

  List<Song> _availableSongs({Set<int>? currentSongIdsToExclude}) {
    final songsBloc = context.read<SongsBloc>();
    return currentSongIdsToExclude != null
        ? songsBloc.state.allSongs
              .where((song) => !currentSongIdsToExclude.contains(song.id))
              .toList()
        : songsBloc.state.allSongs;
  }

  Future<Set<int>?> addSongsToFavorite(
    Set<int>? currentSongIds,
  ) async {
    final selectedSongIds = await Navigator.of(context).push<Set<int>>(
      MaterialPageRoute<Set<int>>(
        builder: (_) => AddSongsPage(
          listName: context.localization.favorites,
          availableSongs: _availableSongs(
            currentSongIdsToExclude: currentSongIds,
          ),
        ),
      ),
    );

    if (selectedSongIds != null && selectedSongIds.isNotEmpty && mounted) {
      for (final songId in selectedSongIds) {
        context.read<FavoriteSongsBloc>().add(ToggleFavoriteSongEvent(songId));
      }

      _showSongsAddedMessage(
        selectedSongIds.length,
        context.localization.favorites,
      );
    }

    return selectedSongIds;
  }

  /// Remove songs from a playlist
  void removeSongsFromPlaylist(Set<int> songIds, Playlist playlist) {
    context.read<PlayListBloc>().add(
      RemoveSongsFromPlaylistEvent(songIds, playlist.id),
    );

    _showSongsRemovedMessage(songIds.length, playlist.name);
  }

  Future<void> showPlaylistSheetForAddingSongs(List<Song> selectedSongs) async {
    await PlaylistsPage.showSheet(
      context: context,
      songIds: selectedSongs.map((song) => song.id).toSet(),
    );
  }

  void _showSongsAddedMessage(int count, String playlistName) {
    if (!mounted) return;

    final songText = count == 1
        ? context.localization.song
        : context.localization.songs;

    AppSnackBar.showSuccess(
      context,
      title: context.localization.addToPlaylist,
      message: '$count $songText • $playlistName',
      icon: Icons.playlist_add_check_circle_rounded,
    );
  }

  void _showSongsRemovedMessage(int count, String playlistName) {
    if (!mounted) return;

    final songText = count == 1
        ? context.localization.song
        : context.localization.songs;

    AppSnackBar.showInfo(
      context,
      title: context.localization.removeFromPlaylist,
      message: '$count $songText • $playlistName',
      icon: Icons.playlist_remove_rounded,
    );
  }
}
