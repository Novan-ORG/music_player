import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) async {
        switch (action) {
          case _MenuAction.addMusicToPlaylist:
            onAddMusicToPlaylist?.call();
            return;
          case _MenuAction.delete:
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
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: _MenuAction.addMusicToPlaylist,
          child: Row(
            spacing: 8,
            children: [
              Icon(Icons.add, color: Colors.green),
              Text('Add music'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: _MenuAction.edit,
          child: Row(
            spacing: 8,
            children: [
              Icon(Icons.edit, color: Colors.orange),
              Text('Rename'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: _MenuAction.delete,
          child: Row(
            spacing: 8,
            children: [
              Icon(Icons.delete, color: Colors.red),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );
  }

  void _showUndoSnackbar(BuildContext context, Playlist playlist) {
    final playlistBloc = context.read<PlayListBloc>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${playlist.name} ${context.localization.deleted}'),
        action: SnackBarAction(
          label: context.localization.undo,
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            playlistBloc.add(UndoDeletePlayListEvent());
          },
        ),
        duration: const Duration(seconds: 20),
      ),
    );
  }
}

enum _MenuAction {
  addMusicToPlaylist,
  delete,
  edit,
}
