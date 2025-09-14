import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocSelector;
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/song_title.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongInfo extends StatelessWidget {
  final SongModel? song;
  final VoidCallback onLikePressed;

  const SongInfo({super.key, required this.song, required this.onLikePressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: SongTitle(song: song),
      subtitle: Text(
        song?.artist ?? 'Unknown Artist',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: BlocSelector<MusicPlayerBloc, MusicPlayerState, List<int>>(
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
