import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_themes.dart';
import 'package:music_player/core/widgets/floating_circle_buttton.dart';
import 'package:music_player/core/widgets/loading.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/entities/entities.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/presentation/widgets/widgets.dart';

/// Main playlists management page.
///
/// Features:
/// - List all playlists
/// - Create new playlist
/// - Delete/rename playlist
/// - Pin/unpin playlists
/// - Selection mode for adding songs
class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({
    super.key,
    this.isSelectionMode = false,
    this.songIds,
  });

  final bool isSelectionMode;
  final Set<int>? songIds;

  static Future<List<int>?> showSheet({
    required BuildContext context,
    Set<int>? songIds,
  }) {
    return showModalBottomSheet<List<int>>(
      context: context,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return PlaylistContentView(
          isSelectionMode: true,
          songIds: songIds,
          onCloseBottomSheet: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  Future<void> _showCreatePlaylistSheet() => CreatePlaylistSheet.show(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PlaylistAppbar(
        onActionPressed: _showCreatePlaylistSheet,
      ),
      body: const PlaylistContentView(
        isSelectionMode: false,
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: _showCreatePlaylistSheet,
      ),
    );
  }
}

class PlaylistContentView extends StatefulWidget {
  const PlaylistContentView({
    required this.isSelectionMode,
    super.key,
    this.songIds,
    this.onCloseBottomSheet,
    this.padding = const EdgeInsets.all(16),
  });

  final bool isSelectionMode;
  final Set<int>? songIds;
  final VoidCallback? onCloseBottomSheet;
  final EdgeInsets padding;

  @override
  State<PlaylistContentView> createState() => _PlaylistContentViewState();
}

class _PlaylistContentViewState extends State<PlaylistContentView> {
  @override
  void initState() {
    super.initState();
    context.read<PlayListBloc>().add(LoadPlayListsEvent());
  }

  List<Playlist> _extractPinnedPlaylists(
    List<Playlist> allPlaylists,
    List<PinPlaylist> pinnedMeta,
  ) {
    final playlistById = <int, Playlist>{
      for (final p in allPlaylists) p.id: p,
    };

    final result = <Playlist>[];

    for (final meta in pinnedMeta) {
      final playlist = playlistById[meta.playlistId];
      if (playlist != null && playlist.id != 0) {
        result.add(playlist);
      }
    }

    return result;
  }

  Widget _buildSheetHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox.shrink(),
          Text(
            context.localization.addSongsToPlaylist,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.close,
                color: AppLightColors.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(PlayListState state, ThemeData theme) {
    if (state.status == PlayListStatus.loading) {
      return const Loading();
    } else if (state.status == PlayListStatus.error) {
      return Center(
        child: Text(
          '${context.localization.error}: ${state.errorMessage}',
        ),
      );
    } else if (state.status == PlayListStatus.initial) {
      return Center(child: Text(context.localization.playListPage));
    } else {
      final pinnedMeta = state.pinnedPlaylists;

      final allPlaylists = state.playLists;

      final pinnedPlaylists = _extractPinnedPlaylists(
        allPlaylists,
        pinnedMeta,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isSelectionMode) _buildSheetHeader(theme),

          if (!widget.isSelectionMode)
            PinnedPlaylistsView(
              pinnedPlaylists: pinnedPlaylists,
            ),
          Expanded(
            child: AllPlaylistView(
              playlists: allPlaylists,
              pinnedMeta: pinnedMeta,
              isSelectionMode: widget.isSelectionMode,
              songIds: widget.songIds,
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: widget.padding,
      child: BlocBuilder<PlayListBloc, PlayListState>(
        builder: (context, state) => _buildBody(state, theme),
      ),
    );
  }
}
