import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/favorite/presentation/widgets/widgets.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/playlist.dart';
import 'package:music_player/features/songs/presentation/pages/songs_selection_page.dart';

class FavoriteSongsPage extends StatefulWidget {
  const FavoriteSongsPage({super.key});

  @override
  State<FavoriteSongsPage> createState() => _FavoriteSongsPageState();
}

class _FavoriteSongsPageState extends State<FavoriteSongsPage>
    with
        SongSharingMixin,
        RingtoneMixin,
        PlaylistManagementMixin,
        SongDeletionMixin {
  late final FavoriteSongsBloc favSongsBloc = context.read<FavoriteSongsBloc>();
  @override
  void initState() {
    super.initState();
    favSongsBloc.add(const LoadFavoriteSongsEvent());
  }

  Future<void> _handleSongTap(int songIndex, List<Song> favoriteSongs) async {
    context.read<MusicPlayerBloc>().add(
      PlayMusicEvent(songIndex, favoriteSongs),
    );

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MusicPlayerPage(),
      ),
    );
  }

  void _handleToggleLike(int songId) {
    favSongsBloc.add(ToggleFavoriteSongEvent(songId));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.favoriteSongs),
        backgroundColor: const Color(0xFF7F53AC),
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
      body: BackgroundGradient(
        child: BlocBuilder<FavoriteSongsBloc, FavoriteSongsState>(
          builder: (context, favoriteState) {
            return _buildContent(
              favoriteState,
            );
          },
        ),
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

    return _buildFavoritesList(favoriteState.favoriteSongs);
  }

  Widget _buildFavoritesList(List<Song> favoriteSongs) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      itemCount: favoriteSongs.length,
      itemBuilder: (context, index) {
        final song = favoriteSongs[index];
        return SongItem(
          song: song,
          isLiked: true,
          onTap: () => _handleSongTap(index, favoriteSongs),
          onLongPress: () => onLongPress(song),
          onToggleLike: () => _handleToggleLike(song.id),
          onSharePressed: () => shareSong(song),
          onSetAsRingtonePressed: () => setAsRingtone(song.data),
          onDeletePressed: () => showDeleteSongDialog(song),
          onAddToPlaylistPressed: () async {
            await PlaylistsPage.showSheet(
              context: context,
              songIds: {song.id},
            );
          },
        );
      },
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
