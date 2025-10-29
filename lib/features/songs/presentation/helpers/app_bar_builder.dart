import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/services/database/models/playlist_model.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/search/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/constants/songs_page_constants.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

/// Helper class for building app bar components
class AppBarBuilder {
  const AppBarBuilder._();

  /// Build the main app bar for normal mode
  static PreferredSizeWidget buildMainAppBar({
    required BuildContext context,
    required PlaylistModel? playlist,
    required bool isFavorites,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(SongsPageConstants.toolbarHeight),
      child: AppBar(
        backgroundColor: SongsPageConstants.appBarColor,
        elevation: 0,
        title: Text(
          _getAppBarTitle(context, playlist, isFavorites),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SongsPageConstants.appBarFontSize,
            letterSpacing: SongsPageConstants.appBarLetterSpacing,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _navigateToSearch(context),
            tooltip: context.localization.searchSongs,
            icon: const Icon(
              Icons.search,
              size: SongsPageConstants.searchIconSize,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the selection mode app bar
  static PreferredSizeWidget buildSelectionAppBar({
    required BuildContext context,
    required SongsState songsState,
    required List<Song> filteredSongs,
    required PlaylistModel? playlist,
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
          isInPlaylist: playlist != null,
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

  static String _getAppBarTitle(
    BuildContext context,
    PlaylistModel? playlist,
    bool isFavorites,
  ) {
    if (isFavorites) {
      return context.localization.favoriteSongs;
    }
    return playlist?.name ?? context.localization.allSongs;
  }

  static Future<void> _navigateToSearch(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SearchSongsPage(),
      ),
    );
  }
}
