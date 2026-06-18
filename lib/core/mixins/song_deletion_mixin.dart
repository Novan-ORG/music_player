import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';

/// Mixin that provides song deletion functionality
mixin SongDeletionMixin<T extends StatefulWidget> on State<T> {
  /// Show delete confirmation dialog for a single song
  Future<void> showDeleteSongDialog(Song song) async {
    final songBloc = context.read<SongsBloc>();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AppConfirmationDialog(
        icon: Icons.delete_outline_rounded,
        title: dialogContext.localization.deleteSong,
        message: dialogContext.localization.areSureYouWantToDeleteSong,
        confirmLabel: dialogContext.localization.deleteFromDevice,
        isDestructive: true,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          songBloc.add(DeleteSongEvent(song));
          _showUndoDeleteSnackbar(song);
        },
      ),
    );
  }

  /// Show delete confirmation dialog for multiple songs
  Future<void> showDeleteSongsDialog(
    List<Song> songs,
  ) async {
    final songBloc = context.read<SongsBloc>();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AppConfirmationDialog(
        icon: Icons.delete_sweep_rounded,
        title: dialogContext.localization.deleteSongsAlertTitle(songs.length),
        message: dialogContext.localization.deleteSongsAlertContent,
        confirmLabel: dialogContext.localization.deleteFromDevice,
        isDestructive: true,
        onConfirm: () {
          songBloc.add(
            DeleteSongsEvent(songs),
          );
          _showDeletedSnackbar(songs.length);
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  void _showUndoDeleteSnackbar(Song song) {
    if (!mounted) return;
    final songBloc = context.read<SongsBloc>();
    final theme = context.theme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
        content: Text(
          '${song.title} ${context.localization.deleted}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        action: SnackBarAction(
          label: context.localization.undo,
          textColor: theme.colorScheme.primary,
          onPressed: () => songBloc.add(const UndoDeleteSongEvent()),
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
    final theme = context.theme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
        content: Text(
          '$count $songText ${context.localization.deleted}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
