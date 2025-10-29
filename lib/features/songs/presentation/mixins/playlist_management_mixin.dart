import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/services/database/models/playlist_model.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/play_list/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/pages/song_selection_page.dart';

/// Mixin that provides playlist management functionality
mixin PlaylistManagementMixin<T extends StatefulWidget> on State<T> {
  /// Add songs to a playlist
  Future<Set<int>?> addSongsToPlaylist(
    PlaylistModel playlist,
    Set<int>? currentSongIds,
  ) async {
    final selectedSongIds = await Navigator.of(context).push<Set<int>>(
      MaterialPageRoute<Set<int>>(
        builder: (_) => SongSelectionPage(
          playlist: playlist,
          excludeIds: currentSongIds ?? {},
        ),
      ),
    );

    if (selectedSongIds != null && selectedSongIds.isNotEmpty && mounted) {
      context.read<PlayListBloc>().add(
        AddSongsToPlaylistsEvent(
          selectedSongIds,
          [playlist.id],
        ),
      );

      _showSongsAddedMessage(selectedSongIds.length, playlist.name);
    }

    return selectedSongIds;
  }

  /// Remove songs from a playlist
  void removeSongsFromPlaylist(
    Set<int> songIds,
    int playlistId,
    String playlistName,
  ) {
    context.read<PlayListBloc>().add(
      RemoveSongsFromPlaylistEvent(songIds, playlistId),
    );

    _showSongsRemovedMessage(songIds.length, playlistName);
  }

  /// Remove a single song from a playlist
  void removeSongFromPlaylist(Song song, int playlistId, String playlistName) {
    removeSongsFromPlaylist({song.id}, playlistId, playlistName);
  }

  void _showSongsAddedMessage(int count, String playlistName) {
    if (!mounted) return;

    final songText = count == 1
        ? context.localization.song
        : context.localization.songs;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count $songText added to $playlistName'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSongsRemovedMessage(int count, String playlistName) {
    if (!mounted) return;

    final songText = count == 1
        ? context.localization.song
        : context.localization.songs;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count $songText removed from $playlistName'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
