import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/songs_count.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/widgets/widgets.dart';

class PlaylistDetailsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const PlaylistDetailsAppbar({
    required this.playlist,
    required this.songCount,
    required this.onAddSongs,
    this.onPlaylistRenamed,
    super.key,
  });

  final Playlist playlist;
  final int songCount;
  final VoidCallback onAddSongs;
  final VoidCallback? onPlaylistRenamed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        playlist.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        PlaylistItemMoreAction(
          playlist: playlist,
          onDeleted: () => Navigator.of(context).pop(),
          onRenamed: onPlaylistRenamed,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (playlist.id != -1)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: ElevatedButton.icon(
                    onPressed: onAddSongs,
                    icon: const Icon(Icons.add),
                    label: Text(context.localization.addSongs),
                  ),
                ),
              ),
            SongsCount(songCount: songCount).padding(value: 12),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight((kToolbarHeight * 2) + 12);
}
