import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocSelector;
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';

class SongInfo extends StatelessWidget {
  const SongInfo({
    required this.song,
    required this.onLikePressed,
    super.key,
  });

  final Song? song;
  final VoidCallback onLikePressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: SongTitle(song: song),
      subtitle: Text(
        song?.artist ?? 'Unknown Artist',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: BlocSelector<MusicPlayerBloc, MusicPlayerState, Set<int>>(
        selector: (state) => state.likedSongIds,
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
    );
  }
}
