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
    super.key,
  });

  final Playlist playlist;
  final int songCount;
  final VoidCallback onAddSongs;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: SongsCount(songCount: songCount).paddingOnly(left: 12),
      leadingWidth: 200,
      flexibleSpace: Center(
        child: Text(
          playlist.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      actions: [PlaylistItemMoreAction(playlist: playlist)],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(
            6,
          ),
          child: ElevatedButton.icon(
            onPressed: onAddSongs,
            icon: const Icon(Icons.add),
            label: Text(context.localization.addSongs),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight((kToolbarHeight * 2) + 12);
}
