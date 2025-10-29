import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';

/// Mixin that provides song deletion functionality
mixin SongDeletionMixin<T extends StatefulWidget> on State<T> {
  /// Show delete confirmation dialog for a single song
  Future<void> showDeleteSongDialog(Song song, SongsBloc songsBloc) async {
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
              _showUndoDeleteSnackbar(song, songsBloc);
            },
            child: Text(context.localization.deleteFromDevice),
          ),
        ],
      ),
    );
  }

  /// Show delete confirmation dialog for multiple songs
  Future<void> showDeleteSongsDialog(
    List<Song> songs,
    SongsBloc songsBloc,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.localization.deleteSongsAlertTitle(songs.length)),
        content: Text(context.localization.deleteSongsAlertContent),
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

  void _showUndoDeleteSnackbar(Song song, SongsBloc songsBloc) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${song.title} ${context.localization.deleted}'),
        action: SnackBarAction(
          label: context.localization.undo,
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () => songsBloc.add(const UndoDeleteSongEvent()),
        ),
        duration: const Duration(seconds: 20),
      ),
    );
  }

  void _showDeletedSnackbar(int count) {
    if (!mounted) return;

    final songText = count > 1
        ? context.localization.songs
        : context.localization.song;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count $songText ${context.localization.deleted}'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
