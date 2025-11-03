import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/constants/songs_page_constants.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

/// Helper class for building app bar components
class AppBarBuilder {
  const AppBarBuilder._();

  /// Build the selection mode app bar
  static PreferredSizeWidget buildSelectionAppBar({
    required BuildContext context,
    required SongsState songsState,
    required List<Song> filteredSongs,
    required VoidCallback onAddToPlaylist,
    required VoidCallback? onRemoveFromPlaylist,
    required VoidCallback onDelete,
    required VoidCallback onShare,
    required VoidCallback onSelectAll,
    required VoidCallback onDeselectAll,
    required VoidCallback onClearSelection,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(SongsPageConstants.toolbarHeight),
      child: SafeArea(
        child: SelectionActionBar(
          selectedCount: songsState.selectedSongIds.length,
          totalCount: filteredSongs.length,
          onAddToPlaylist: onAddToPlaylist,
          onRemoveFromPlaylist: onRemoveFromPlaylist,
          onDelete: onDelete,
          onShare: onShare,
          onSelectAll: onSelectAll,
          onDeselectAll: onDeselectAll,
          onClearSelection: onClearSelection,
        ),
      ),
    );
  }
}
