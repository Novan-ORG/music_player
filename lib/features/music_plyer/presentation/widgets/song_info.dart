import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocSelector;
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/favorite.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';

class SongInfo extends StatelessWidget {
  const SongInfo({
    required this.song,
    this.onLikePressed,
    this.onAddToPlaylistPressed,
    this.onSetAsRingtonePressed,
    this.onDeletePressed,
    super.key,
  });

  final Song? song;
  final VoidCallback? onLikePressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onSetAsRingtonePressed;
  final VoidCallback? onAddToPlaylistPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: SongTitle(songTitle: song?.title),
      subtitle: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          const Icon(
            Icons.person,
            size: 14,
            color: Colors.grey,
          ),
          Text(
            song?.artist ?? 'Unknown Artist',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocSelector<FavoriteSongsBloc, FavoriteSongsState, Set<int>>(
            selector: (state) => state.favoriteSongIds,
            builder: (context, likedSongIds) {
              final isLiked = likedSongIds.contains(song?.id ?? -1);
              return IconButton(
                onPressed: onLikePressed,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                  color: isLiked ? Colors.red : null,
                ),
              );
            },
          ),
          _buildPopupMenu(context),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      tooltip: 'More options',
      onSelected: (value) {
        if (value == 'delete') {
          onDeletePressed?.call();
        } else if (value == 'ringtone') {
          onSetAsRingtonePressed?.call();
        } else if (value == 'add_to_playlist') {
          onAddToPlaylistPressed?.call();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'add_to_playlist',
          child: Row(
            spacing: 8,
            children: [
              const Icon(Icons.playlist_add, color: Colors.green),
              Text(context.localization.addToPlaylist),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            spacing: 8,
            children: [
              const Icon(Icons.delete, color: Colors.red),
              Text(context.localization.deleteFromDevice),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'ringtone',
          child: Row(
            spacing: 8,
            children: [
              const Icon(Icons.music_note, color: Colors.blue),
              Text(context.localization.setAsRingtone),
            ],
          ),
        ),
      ],
    );
  }
}
