import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/mixins/playlist_management_mixin.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/entities/pin_playlist.dart';
import 'package:music_player/features/playlist/domain/entities/playlist.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/presentation/widgets/widgets.dart';
import 'package:music_player/injection/service_locator.dart';

class AllPlaylistView extends StatefulWidget {
  const AllPlaylistView({
    required this.playlists,
    required this.pinnedMeta,
    required this.isSelectionMode,
    super.key,
    this.songIds,
    this.onCreatePressed,
  });

  final List<Playlist> playlists;
  final List<PinPlaylist> pinnedMeta;
  final bool isSelectionMode;

  final Set<int>? songIds;
  final VoidCallback? onCreatePressed;

  @override
  State<AllPlaylistView> createState() => _AllPlaylistViewState();
}

class _AllPlaylistViewState extends State<AllPlaylistView>
    with PlaylistManagementMixin {
  final Set<int> selectedPlaylistIds = {};

  Future<void> _showCreatePlaylistSheet() => CreatePlaylistSheet.show(context);

  Future<void> _refreshPlaylists() async {
    final bloc = context.read<PlayListBloc>();
    final completed = bloc.stream.firstWhere(
      (state) => state.status != PlayListStatus.loading,
    );

    bloc.add(LoadPlayListsEvent());
    await completed;
  }

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
      getRecentlyPlayedSongs: getIt.get(),
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
        builder: (_) => AppRouteBlocScope.fromContext(
          context: context,
          child: PlaylistDetailsPage(
            playlistModel: playlist,
          ),
        ),
      ),
    );
  }

  Widget? _buildBottomBar() {
    if (widget.isSelectionMode && widget.songIds != null) {
      final theme = context.theme;

      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final useColumn = constraints.maxWidth < 440;
                final selectionChip = Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${selectedPlaylistIds.length} '
                    '${context.localization.selected}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );

                VoidCallback? onPressed() {
                  if (selectedPlaylistIds.isEmpty) {
                    return null;
                  }
                  return () {
                    Navigator.of(context).pop(selectedPlaylistIds.toList());
                  };
                }

                final actionButton = FilledButton.icon(
                  onPressed: onPressed(),
                  icon: const Icon(Icons.playlist_add_check_rounded),
                  label: Text(context.localization.addToSelectedPlaylist),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                );

                if (useColumn) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      selectionChip,
                      const SizedBox(height: 12),
                      actionButton,
                    ],
                  );
                }

                return Row(
                  children: [
                    selectionChip,
                    const SizedBox(width: 12),
                    Expanded(child: actionButton),
                  ],
                );
              },
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
    final theme = context.theme;
    final isSelectionMode = widget.isSelectionMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: isSelectionMode ? 2 : 16),
        if (isSelectionMode)
          _SelectionModeHeader(
            playlistCount: widget.playlists.length,
            selectedCount: selectedPlaylistIds.length,
            onCreatePressed: widget.onCreatePressed ?? _showCreatePlaylistSheet,
          )
        else
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 12,
            spacing: 12,
            children: [
              Text(
                context.localization.allPlaylists,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${widget.playlists.length} '
                      '${context.localization.playlists}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        SizedBox(height: widget.isSelectionMode ? 12 : 16),
        if (widget.playlists.isEmpty)
          Expanded(
            child: EmptyPlaylist(
              onAddPressed: widget.onCreatePressed ?? _showCreatePlaylistSheet,
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPlaylists,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.only(
                  bottom: widget.isSelectionMode ? 96 : 120,
                ),
                itemCount: widget.playlists.length,
                separatorBuilder: (_, _) =>
                    SizedBox(height: widget.isSelectionMode ? 6 : 2),
                itemBuilder: (context, index) {
                  return _buildPlaylistTile(
                    widget.playlists[index],
                    widget.pinnedMeta,
                  );
                },
              ),
            ),
          ),
        if (widget.isSelectionMode) _buildBottomBar()!,
      ],
    );
  }
}

class _SelectionModeHeader extends StatelessWidget {
  const _SelectionModeHeader({
    required this.playlistCount,
    required this.selectedCount,
    required this.onCreatePressed,
  });

  final int playlistCount;
  final int selectedCount;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 10,
      spacing: 10,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _HeaderChip(
              label: '$playlistCount ${context.localization.playlists}',
            ),
            if (selectedCount > 0)
              _HeaderChip(
                label: '$selectedCount ${context.localization.selected}',
                emphasized: true,
              ),
          ],
        ),
        FilledButton.tonalIcon(
          onPressed: onCreatePressed,
          icon: const Icon(Icons.add_rounded),
          label: Text(context.localization.createPlaylist),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({
    required this.label,
    this.emphasized = false,
  });

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: emphasized
            ? primary.withValues(alpha: 0.12)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: emphasized ? primary : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
