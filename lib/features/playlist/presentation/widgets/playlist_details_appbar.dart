import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/songs_count.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/widgets/playlist_image_widget.dart';

class PlaylistDetailsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const PlaylistDetailsAppbar({
    required this.playlist,
    required this.onSearchButtonPressed,
    required this.songCount,
    super.key,
  });

  final Playlist playlist;
  final int songCount;
  final VoidCallback onSearchButtonPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        context.localization.playlist,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onSearchButtonPressed,
          tooltip: context.localization.searchSongs,
          icon: const Icon(
            Icons.search,
          ),
        ).paddingSymmetric(horizontal: 6),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 8,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            playlist.name,
                            style: theme.textTheme.titleLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SongsCount(songCount: songCount),
                        ],
                      ),
                    ),
                    PlaylistImageWidget(
                      playlistId: playlist.id,
                      borderRadius: 8,
                      size: 118,
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.3,
                indent: 18,
                endIndent: 18,
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight((kToolbarHeight * 3.4) + 27);
}
