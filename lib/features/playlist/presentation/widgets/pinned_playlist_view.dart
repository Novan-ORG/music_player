import 'package:flutter/material.dart';
import 'package:music_player/features/playlist/domain/entities/playlist.dart';
import 'package:music_player/features/playlist/presentation/pages/playlist_details_page.dart';
import 'package:music_player/features/playlist/presentation/widgets/recently_playlist_item.dart';

class PinnedPlaylistsView extends StatelessWidget {
  const PinnedPlaylistsView({
    required this.pinnedPlaylists,
    super.key,
  });

  final List<Playlist> pinnedPlaylists;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Favorite Playlist',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: pinnedPlaylists.length + 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final recently = Playlist(
                id: 0,
                name: 'Recently',
                numOfSongs: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              if (index == 0) {
                return PinnedPlaylistItem(
                  playlist: recently,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PlaylistDetailsPage(
                        playlistModel: recently,
                      ),
                    ),
                  ),
                );
              }
              final playlist = pinnedPlaylists[index - 1];

              return Padding(
                padding: const EdgeInsets.only(left: 16),
                child: PinnedPlaylistItem(
                  playlist: playlist,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PlaylistDetailsPage(
                        playlistModel: playlist,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.3,
          indent: 6,
          endIndent: 6,
          height: 6,
        ),
      ],
    );
  }
}
