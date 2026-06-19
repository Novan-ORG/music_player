import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/playlist.dart';

class PlaylistItemMoreAction extends StatelessWidget {
  const PlaylistItemMoreAction({
    required this.playlist,
    this.onDeleted,
    this.onRenamed,
    this.onAddMusicToPlaylist,
    super.key,
  });
  final Playlist playlist;
  final VoidCallback? onDeleted;
  final VoidCallback? onRenamed;
  final VoidCallback? onAddMusicToPlaylist;

  @override
  Widget build(BuildContext context) {
    return AppPopupMenuButton<_MenuAction>(
      compact: true,
      tooltip: context.localization.moreOptions,
      onSelected: (action) async {
        switch (action) {
          case _MenuAction.addMusicToPlaylist:
            onAddMusicToPlaylist?.call();
            return;
          case _MenuAction.delete:
            final confirmed = await _showDeleteConfirmation(context);
            if (!context.mounted || !confirmed) {
              return;
            }
            context.read<PlayListBloc>().add(
              DeletePlayListEvent(playlist.id),
            );
            _showUndoSnackbar(context, playlist);
            onDeleted?.call();
            return;
          case _MenuAction.edit:
            await CreatePlaylistSheet.showEdit(context, playlist);
            onRenamed?.call();
            return;
        }
      },
      items: [
        AppPopupMenuEntry(
          value: _MenuAction.addMusicToPlaylist,
          label: context.localization.addSongs,
          icon: Icons.playlist_add_rounded,
          iconColor: Colors.green,
        ),
        AppPopupMenuEntry(
          value: _MenuAction.edit,
          label: context.localization.rename,
          icon: Icons.edit_rounded,
          iconColor: Colors.orange,
        ),
        AppPopupMenuEntry(
          value: _MenuAction.delete,
          label: context.localization.delete,
          icon: Icons.delete_outline_rounded,
          isDestructive: true,
        ),
      ],
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppConfirmationDialog(
        icon: Icons.playlist_remove_rounded,
        title: dialogContext.localization.delete,
        message: '${dialogContext.localization.playlist}: ${playlist.name}',
        confirmLabel: dialogContext.localization.delete,
        isDestructive: true,
        onConfirm: () => Navigator.of(dialogContext).pop(true),
      ),
    );

    return confirmed ?? false;
  }

  void _showUndoSnackbar(BuildContext context, Playlist playlist) {
    final playlistBloc = context.read<PlayListBloc>();
    AppSnackBar.showInfo(
      context,
      title: context.localization.deleted,
      message: playlist.name,
      icon: Icons.playlist_remove_rounded,
      actionLabel: context.localization.undo,
      onAction: () {
        playlistBloc.add(UndoDeletePlayListEvent());
      },
      duration: const Duration(seconds: 20),
    );
  }
}

enum _MenuAction {
  addMusicToPlaylist,
  delete,
  edit,
}
