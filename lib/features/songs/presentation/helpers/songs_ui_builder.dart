import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/constants/songs_page_constants.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

/// Helper class for building song-related UI components
class SongsUIBuilder {
  const SongsUIBuilder._();

  /// Build an empty state widget
  static Widget buildEmptyState({
    required BuildContext context,
    required String message,
    required VoidCallback onRefresh,
  }) {
    return NoSongsWidget(
      message: message,
      onRefresh: onRefresh,
    );
  }

  /// Build loading state widget
  static Widget buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Build error state widget
  static Widget buildErrorState({
    required BuildContext context,
    required VoidCallback onRetry,
  }) {
    return buildEmptyState(
      context: context,
      message: context.localization.errorLoadingSongs,
      onRefresh: onRetry,
    );
  }

  /// Build the songs list view
  static Widget buildSongsList({
    required BuildContext context,
    required List<Song> songs,
    required Set<int> likedSongIds,
    required SongsState songsState,
    required Widget Function({
      required BuildContext context,
      required int songIndex,
      required Song song,
      required bool isSelected,
    })
    itemBuilder,
  }) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        vertical: SongsPageConstants.listVerticalPadding,
        horizontal: SongsPageConstants.listHorizontalPadding,
      ),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        final isSelected = songsState.selectedSongIds.contains(song.id);

        return itemBuilder(
          context: context,
          songIndex: index,
          song: song,
          isSelected: isSelected,
        );
      },
    );
  }

  /// Build the main content column
  static Widget buildMainContent({
    required List<Widget> children,
  }) {
    return Column(children: children);
  }

  /// Build the refresh indicator wrapper
  static Widget buildRefreshWrapper({
    required Widget child,
    required Future<void> Function() onRefresh,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: child,
    );
  }

  /// Get appropriate empty message based on page type
  static String getEmptyMessage({
    required BuildContext context,
    required bool isFavorites,
    required bool isPlaylist,
  }) {
    if (isFavorites) {
      return context.localization.noFavoriteSong;
    }
    if (isPlaylist) {
      return context.localization.noSongInPlaylist;
    }
    return context.localization.noSongTryAgain;
  }
}
