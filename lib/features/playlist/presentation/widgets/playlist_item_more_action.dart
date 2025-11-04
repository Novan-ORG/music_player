import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/playlist.dart';

class PlaylistItemMoreAction extends StatelessWidget {
  const PlaylistItemMoreAction({
    required this.playlist,
    this.onDeleted,
    this.onRenamed,
    super.key,
  });
  final Playlist playlist;
  final VoidCallback? onDeleted;
  final VoidCallback? onRenamed;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'delete') {
          context.read<PlayListBloc>().add(
            DeletePlayListEvent(playlist.id),
          );
          _showUndoSnackbar(context, playlist);
          onDeleted?.call();
        } else if (value == 'rename') {
          await CreatePlaylistSheet.showEdit(context, playlist);
          onRenamed?.call();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'rename',
          child: Text(context.localization.rename),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text(context.localization.delete),
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
