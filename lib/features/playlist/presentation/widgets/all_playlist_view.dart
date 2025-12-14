import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/mixins/playlist_management_mixin.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/entities/pin_playlist.dart';
import 'package:music_player/features/playlist/domain/entities/playlist.dart';
import 'package:music_player/features/playlist/presentation/bloc/playlist_bloc.dart';
import 'package:music_player/features/playlist/presentation/bloc/playlist_details_bloc.dart';
import 'package:music_player/features/playlist/presentation/pages/playlist_details_page.dart';
import 'package:music_player/features/playlist/presentation/widgets/create_playlist_sheet.dart';
import 'package:music_player/features/playlist/presentation/widgets/playlist_item.dart';
import 'package:music_player/injection/service_locator.dart';

class AllPlaylistView extends StatefulWidget {
  const AllPlaylistView({
    required this.playlists,
    required this.pinnedMeta,
    required this.isSelectionMode,
    super.key,
    this.songIds,
  });

  final List<Playlist> playlists;
  final List<PinPlaylist> pinnedMeta;
  final bool isSelectionMode;

  final Set<int>? songIds;

  @override
  State<AllPlaylistView> createState() => _AllPlaylistViewState();
}

class _AllPlaylistViewState extends State<AllPlaylistView>
    with PlaylistManagementMixin {
  final Set<int> selectedPlaylistIds = {};

  Future<void> _showCreatePlaylistSheet() => CreatePlaylistSheet.show(context);

  void _handlePinPlaylist(Playlist playlist) {
    context.read<PlayListBloc>().add(
      PinnedPlaylistEvent(playlist.id),
    );
  }

  void _onTapToSelectMusic(int id) {
    setState(() {
      if (selectedPlaylistIds.contains(id)) {
        selectedPlaylistIds.remove(id);
      } else {
        selectedPlaylistIds.add(id);
      }
    });
  }

  Future<void> _handleAddMusicToPlaylist(Playlist playlist) async {
    final detailsBloc = PlaylistDetailsBloc(
      playlist: playlist,
      getPlaylistSongs: getIt.get(),
    )..add(const GetPlaylistSongsEvent());

    try {
      await detailsBloc.stream.firstWhere(
        (state) => state.status != PlaylistDetailsStatus.loading,
      );

      Set<int>? currentSongIds;
      final state = detailsBloc.state;
      if (state.status == PlaylistDetailsStatus.success) {
        currentSongIds = state.songs.map((song) => song.id).toSet();
      }

      await addSongsToPlaylist(
        playlist,
        currentSongIds,
      );
    } finally {
      await detailsBloc.close();
    }
  }

  void _navigateToPlaylistDetails(Playlist playlist) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlaylistDetailsPage(
          playlistModel: playlist,
        ),
      ),
    );
  }

  Widget? _buildBottomBar() {
    if (widget.isSelectionMode && widget.songIds != null) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.playlist_add_check),
            label: Text(context.localization.addToSelectedPlaylist),
            onPressed: selectedPlaylistIds.isEmpty
                ? null
                : () {
                    context.read<PlayListBloc>().add(
                      AddSongsToPlaylistsEvent(
                        widget.songIds!,
                        selectedPlaylistIds.toList(),
                      ),
                    );
                    Navigator.of(
                      context,
                    ).pop(selectedPlaylistIds.toList());
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      );
    }
    return null;
  }

  Widget _buildPlaylistTile(
    Playlist playlist,
    List<PinPlaylist> pinnedMeta,
  ) {
    final isPinned = pinnedMeta.any((p) => p.playlistId == playlist.id);
    if (widget.isSelectionMode) {
      return PlaylistItem(
        playlist: playlist,
        isSelectionMode: widget.isSelectionMode,
        isSelected: selectedPlaylistIds.contains(playlist.id),
        onTap: () => _onTapToSelectMusic(playlist.id),
      );
    } else {
      return PlaylistItem(
        playlist: playlist,
        isPinned: isPinned,
        onAddMusicToPlaylist: () => _handleAddMusicToPlaylist(playlist),
        onTap: () => _navigateToPlaylistDetails(playlist),
        onPinned: () => _handlePinPlaylist(playlist),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'All Playlist',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.isSelectionMode)
              GestureDetector(
                onTap: _showCreatePlaylistSheet,
                child: Text(
                  'Create Playlist',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.playlists.length,
            itemBuilder: (context, index) {
              return _buildPlaylistTile(
                widget.playlists[index],
                widget.pinnedMeta,
              );
            },
          ),
        ),

        if (widget.isSelectionMode) _buildBottomBar()!,
      ],
    );
  }
}
