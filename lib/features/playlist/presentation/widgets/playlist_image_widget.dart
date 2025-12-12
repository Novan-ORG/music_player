import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';

class PlaylistImageWidget extends StatelessWidget {
  const PlaylistImageWidget({
    required this.playlistId,
    this.borderRadius = 12,
    super.key,
  });

  final int playlistId;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayListBloc, PlayListState>(
      builder: (context, state) {
        // Get cover song ID from bloc state
        final coverSongId = state.playlistCoverSongIds[playlistId];
        final artworkId = coverSongId ?? playlistId;

        return SongImageWidget(
          songId: artworkId,
          defaultCover: ImageAssets.playlistCover,
          borderRadius: borderRadius,
        );
      },
    );
  }
}
