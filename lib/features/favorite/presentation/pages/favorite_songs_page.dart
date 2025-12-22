import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/views/views.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/favorite/presentation/widgets/widgets.dart';
import 'package:music_player/features/songs/presentation/pages/songs_selection_page.dart';

/// Page displaying all favorite songs.
///
/// Features:
/// - Favorite songs list
/// - Play song functionality
/// - Remove from favorites
/// - Empty state handling
class FavoriteSongsPage extends StatefulWidget {
  const FavoriteSongsPage({super.key});

  @override
  State<FavoriteSongsPage> createState() => _FavoriteSongsPageState();
}

class _FavoriteSongsPageState extends State<FavoriteSongsPage> {
  late final FavoriteSongsBloc favSongsBloc = context.read<FavoriteSongsBloc>();
  @override
  void initState() {
    super.initState();
    favSongsBloc.add(const LoadFavoriteSongsEvent());
  }

  void onLongPress(Song song) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SongsSelectionPage(
          title: context.localization.favoriteSongs,
          availableSongs: favSongsBloc.state.favoriteSongs,
          selectedSongIds: {song.id},
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    favSongsBloc.add(const LoadFavoriteSongsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.favoriteSongs),
        elevation: 0,
        actions: [
          BlocBuilder<FavoriteSongsBloc, FavoriteSongsState>(
            builder: (context, state) {
              if (state.favoriteSongs.isEmpty) return const SizedBox.shrink();

              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'clear_all') {
                    _showClearAllDialog();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        const Icon(Icons.clear_all, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(context.localization.clearAll),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoriteSongsBloc, FavoriteSongsState>(
        builder: (context, favoriteState) {
          return _buildContent(
            favoriteState,
          );
        },
      ),
    );
  }

  Widget _buildContent(
    FavoriteSongsState favoriteState,
  ) {
    if (favoriteState.status == FavoriteSongsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favoriteState.status == FavoriteSongsStatus.error) {
      return FavoriteErrorWidget(
        message: context.localization.errorLoadingSongs,
        onRetry: () => favSongsBloc.add(
          const LoadFavoriteSongsEvent(),
        ),
      );
    }

    if (favoriteState.favoriteSongs.isEmpty) {
      return FavoriteEmptyWidget(
        onRefresh: () {
          favSongsBloc.add(const LoadFavoriteSongsEvent());
        },
      );
    }

    return SongsView(
      songs: favoriteState.favoriteSongs,
      onRefresh: onRefresh,
    );
  }

  void _showClearAllDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.localization.clearAll),
        content: Text(
          context.localization.areYouSureYouWantToClearAllFavorites,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.localization.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              favSongsBloc.add(
                const ClearAllFavoritesEvent(),
              );
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
